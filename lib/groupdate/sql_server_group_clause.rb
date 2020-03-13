require 'json'

# ----------------------------------------------------------------------
# 2017-05-13T01:17:42Z  YEAR  select dateadd(YEAR, datediff(YEAR, 0, {field}), 0) 2017-01-01T00:00:00Z
# 2017-05-13T01:17:42Z  QUARTER select dateadd(QUARTER, datediff(QUARTER, 0, {field}), 0) 2017-04-01T00:00:00Z
# 2017-05-13T01:17:42Z  MONTH select dateadd(MONTH, datediff(MONTH, 0, {field}), 0) 2017-05-01T00:00:00Z
# 2017-05-13T01:17:42Z  WEEK  select dateadd(WEEK, datediff(WEEK, 0, {field}), 0) 2017-05-08T00:00:00Z
# 2017-05-13T01:17:42Z  DAY select dateadd(DAY, datediff(DAY, 0, {field}), 0) 2017-05-13T00:00:00Z
# 2017-05-13T01:17:42Z  HOUR  select dateadd(HOUR, datediff(HOUR, 0, {field}), 0) 2017-05-13T01:00:00Z
# ----------------------------------------------------------------------

module Groupdate
  module SqlServerGroupClause
    def sql_server_group_clause(tzid)
      time_zone = to_windows_tz(tzid)
      raise Groupdate::Error, "unknown timezone: #{tzid}" if time_zone.nil?
      if day_start.to_i > 0
        adjusted_column = "DATEADD(second, #{day_start.to_i * -1}, #{column})"
      else
        adjusted_column = column
      end
      group_column = "#{adjusted_column} AT TIME ZONE 'UTC' AT TIME ZONE '#{time_zone}'"
      day_of_week = "(@@DATEFIRST + DATEPART(weekday, #{group_column}) - 1) %% 7"

      case period
      when :day_of_week
        # - SQL Server settings:
        # - @@DATEFIRST : the start day setting of sql_server
        # - @@DATEFIRST defaults to 7, Sunday
        # - Monday..Sunday => 1..7
        # - Specifying SET DATEFIRST has no effect on DATEDIFF. DATEDIFF always uses Sunday as the first day of the week to ensure the function operates in a deterministic way.
        #
        # - GroupDate day_of_week = "(@@DATEFIRST + DATEPART(weekday, #{group_column}) - 1) %% 7": Sunday = 0, Monday = 1, .. Sat = 6
        return day_of_week
      when :hour_of_day
        dp = 'hour'
      when :minute_of_hour
        dp = 'minute'
      when :day_of_month
        dp = 'day'
      when :month_of_year
        dp = 'month'
      when :day_of_year
        dp = 'dayofyear'
      when :week
        # --------------------------------------------------
        # - GroupDate week_start: Monday..Sunday => 0..6, default to 6 (Sunday)
        # [:mon, :tue, :wed, :thu, :fri, :sat, :sun].index
        day_offset = "-(7 + (#{day_of_week}) - (#{(week_start + 1) % 7})) %% 7"
        date_str = "CONVERT(varchar(30), DATEADD(DAY, #{day_offset}, #{group_column}), 102)"
        return "CAST(#{date_str} AS DATETIME2(0)) AT TIME ZONE '#{time_zone}'"
      when :quarter
        return "CONCAT(DATEPART(year, #{group_column}), '-', DATEPART(quarter, #{group_column}))"
      when :year
        return "CONCAT(DATEPART(year, #{group_column}), '-01-01 00:00:00')"
      else
        style, len =
          case period
          when :second
            [120, 30]
          when :minute
            [120, 16]
          when :hour
            [120, 13]
          when :day
            [102, 30]
          when :month
            [102, 7]
          else
            raise Groupdate::Error, "'#{period}' not supported for SQL Server"
          end

        return "CONVERT(varchar(#{len}), #{group_column}, #{style})"
      end

      return "DATEPART(#{dp}, #{group_column})"
    end

    private

    WINDOWS_ZONES = JSON.parse(File.read(File.join(__dir__, 'windows_zones.json')))
    def to_windows_tz(tzid)
      WINDOWS_ZONES.fetch(tzid, nil)
    end

    def week_base(time_zone)
      sun_base = Time.use_zone('UTC') { Time.zone.parse('1970-01-04 00:00:00') }
      week_start_base = (sun_base + ((week_start + 1) % 7).to_i.days).strftime('%F %T')
      return "CAST('#{sun_base.strftime('%F %T')}' AS DATETIME2(0)) AT TIME ZONE '#{time_zone}'",
             "CAST('#{week_start_base}' AS DATETIME2(0)) AT TIME ZONE '#{time_zone}'"
    end
  end
end
