class TouchOnTime
  SCRIPT_PATH   = '/root/TouchOnTimeChecker/main.py'.freeze

  attr_reader :total_over_time

  def initialize
    script_result = `python #{SCRIPT_PATH}`
    @total_over_time = script_result.to_f
  end
end
