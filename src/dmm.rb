class Dmm
  SCRIPT_PATH   = '/root/DmmMvnoChecker/main.py'.freeze
  MAX_CAPACITY  = 3000.freeze

  attr_reader :remaing_capacity

  def initialize(remaing_capacity: nil)
    @remaing_capacity = remaing_capacity
    unless @remaing_capacity
      script_result = `python #{SCRIPT_PATH}`
      raise script_result unless script_result =~ /MB$/
      @remaing_capacity = script_result.split('MB').first.tr(',', '').to_i
    end
  end

  # 通信制限中か？
  def used_up?
    @remaing_capacity.zero?
  end

  # 使用量
  def used_capacity
    MAX_CAPACITY - @remaing_capacity
  end

  # 使用量の割合
  def used_rate
    ((used_capacity.to_f / MAX_CAPACITY.to_f) * 100).round(2)
  end

  # 残容量の割合
  def remaing_rate
    (100.0 - used_rate).round(2)
  end

  #
  # 残量用の目安
  # ex) 今月残り1/3の場合、33.3を戻す
  #
  def remaing_rate_indication
    days_rate = Util.days_rate_by(date: Date.today)
    ((1 - days_rate) * 100).to_i
  end

end
