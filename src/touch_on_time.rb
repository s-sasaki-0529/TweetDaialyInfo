require 'json'
class TouchOnTime
  SCRIPT_PATH   = '/root/TouchOnTimeChecker/main.py'.freeze

  def initialize(date)
    script_response = `python #{SCRIPT_PATH} #{date.day}`
    script_results  = JSON.parse(script_response)

    @days_start_time = script_results['days_start_time']
    @days_end_time   = script_results['days_end_time']
    @total_over_time = script_results['total_over_time']
    @days_over_time  = script_results['days_over_time']
  rescue
    @days_start_time = @days_end_time = @total_over_time = @days_over_time = nil
  end

  def total_over_time_str
    time_str(@total_over_time)
  end

  def days_over_time_str
    time_str(@days_over_time)
  end

  def days_working_time_str
    if @days_start_time && @days_end_time
      "#{@days_start_time}~#{@days_end_time}"
    else
      '勤怠情報なし'
    end
  end

  private
    def time_str(str)
      return '出勤情報なし' if str.nil?
      str = str.to_f
      str >= 0 ? "+#{str}時間" : "#{str}時間"
    end
end
