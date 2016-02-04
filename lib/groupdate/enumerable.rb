module Enumerable
  Groupdate::PERIODS.each do |period|
    define_method :"group_by_#{period}" do |options = {}, &block|
      if block
        Groupdate::Magic.new(period, options).group_by(self, &block)
      elsif respond_to?(:scoping)
        scoping { @klass.send(:"group_by_#{period}", options, *args, &block) }
      else
        raise ArgumentError, "no block given"
      end
    end
  end

  def group_by_period(period, options = {}, &block)
    # to_sym is unsafe on user input, so convert to strings
    permitted_periods = ((options[:permit] || Groupdate::PERIODS).map(&:to_sym) & Groupdate::PERIODS).map(&:to_s)
    if permitted_periods.include?(period.to_s)
      send("group_by_#{period}", options, &block)
    else
      raise ArgumentError, "Unpermitted period"
    end
  end
end
