require 'json'

module Groupdate
  module SqlServerGroupClause
    def sql_server_group_clause(tzid)
      time_zone = to_windows_tz(tzid)
      raise Groupdate::Error, "unknown timezone: #{tzid}" if time_zone.nil?

      datetime_column = "(CAST(#{column} AS DATETIME2(3)) AT TIME ZONE 'UTC')"
      if day_start.to_i > 0
        adjusted_column = "DATEADD(second, #{day_start.to_i * -1}, #{datetime_column})"
      else
        adjusted_column = datetime_column
      end

      # To work with Date column, cast it to DATETIME2 first
      group_column = "#{adjusted_column} AT TIME ZONE '#{time_zone}'"
      day_of_week = "(@@DATEFIRST + DATEPART(weekday, #{group_column}) - 1) %% 7"

      if period == :day_of_week
        # - SQL Server settings:
        # - @@DATEFIRST : the start day setting of sql_server
        # - @@DATEFIRST defaults to 7, Sunday
        # - Monday..Sunday => 1..7
        # - Specifying SET DATEFIRST has no effect on DATEDIFF. DATEDIFF always uses Sunday as the first day of the week to ensure the function operates in a deterministic way.
        #
        # - GroupDate day_of_week = "(@@DATEFIRST + DATEPART(weekday, #{group_column}) - 1) %% 7": Sunday = 0, Monday = 1, .. Sat = 6
        return day_of_week
      elsif %i(hour_of_day minute_of_hour day_of_month month_of_year day_of_year).include?(period)
        case period
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
        end
        return "DATEPART(#{dp}, #{group_column})"
      else
        case period
        when :week
          # --------------------------------------------------
          # - GroupDate week_start: Monday..Sunday => 0..6, default to 6 (Sunday)
          # [:mon, :tue, :wed, :thu, :fri, :sat, :sun].index
          day_offset = "-(7 + (#{day_of_week}) - (#{(week_start + 1) % 7})) %% 7"
          date_str = "CONVERT(varchar(30), DATEADD(DAY, #{day_offset}, #{group_column}), 102)"
        when :quarter
          date_str = "CONCAT(DATEPART(year, #{group_column}), '-', ((DATEPART(quarter, #{group_column}) - 1) * 3 + 1), '-01')"
        when :year
          date_str = "CONCAT(DATEPART(year, #{group_column}), '-01-01 00:00:00')"
        when :month
          date_str = "CONCAT(CONVERT(varchar(7), #{group_column}, 23), '-01')"
        when :day
          date_str = "CONVERT(varchar(30), #{group_column}, 23)"
        when :second
          date_str = "CONVERT(varchar(30), #{group_column}, 120)"
        when :minute
          date_str = "CONCAT(CONVERT(varchar(16), #{group_column}, 120), ':00')"
        when :hour
          date_str = "CONCAT(CONVERT(varchar(13), #{group_column}, 120), ':00:00')"
        else
          raise Groupdate::Error, "'#{period}' not supported for SQL Server"
        end

        converted_datetime_column = "CAST(#{date_str} AS DATETIME2(0)) AT TIME ZONE '#{time_zone}'"
        if day_start.to_i > 0
          return "DATEADD(second, #{day_start.to_i}, #{converted_datetime_column})"
        else
          return converted_datetime_column
        end
      end
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
