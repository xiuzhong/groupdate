module Groupdate
  module SqlServerGroupClause
    def sql_server_group_clause
      raise Groupdate::Error, "day_start not supported for SQL Server" unless day_start == 0

      group_column = "DATEPART(?, #{column} AT TIME ZONE 'UTC' AT TIME ZONE '?')"
      case period
      when :minute_of_hour
        [group_column, 'minute', time_zone]
      when :hour_of_day
        [group_column, 'hour', time_zone]
      when :day_of_week
        [group_column, 'weekday', time_zone]
      when :day_of_month
        [group_column, 'day', time_zone]
      when :day_of_year
        [group_column, 'dayofyear', time_zone]
      when :month_of_year
        [group_column, 'month', time_zone]
      when :week
        [group_column, 'week', time_zone]
      when :quarter
        [group_column, 'quarter', time_zone]
      when :year
        [group_column, 'year', time_zone]
      else
        style, len =
          case period
          when :second
            [120, 30]
          when :minute
            [120, 16]
          when :hour
            [120, 16]
          when :day
            [102, 30]
          when :month
            [102, 7]
          else # year
            raise Groupdate::Error, "'#{period}' not supported for SQL Server"
          end

        ["CONVERT(varchar(#{len}), #{column} AT TIME ZONE 'UTC' AT TIME ZONE '?', #{style})", timezone]
      end
    end
  end
end
