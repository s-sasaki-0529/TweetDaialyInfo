require 'google/apis/analyticsreporting_v4'

#
# Googleアナリティクスの各種APIを利用するクラス
# 本クラスと同ディレクトリに、'google_analytics_auth.json'を配置すること
#
class Analytics

  #
  # レポート対象を指定してオブジェクトを生成
  # @param [String] view_id   ビューID
  #
  def initialize(view_id)
    @view_id  = view_id
    @analytics = Google::Apis::AnalyticsreportingV4
    auth
  end

  #
  # 指定した日のページごとのユーザ数を集計する
  # @param  [String] date 日付を表す文字列(todayなども可)
  # @return [Hash]   累計ユーザ数及びページごとのユーザ数
  #
  def report_sessions_count_by_date(date)
    date_range = @analytics::DateRange.new(start_date: date, end_date: date)
    metric = @analytics::Metric.new(expression: 'ga:sessions', alias: 'sessions')
    dimension = @analytics::Dimension.new(name: 'ga:pagePath')
    order_by = @analytics::OrderBy.new(field_name: 'ga:sessions', sort_order: 'DESCENDING')
    request = @analytics::GetReportsRequest.new(
      report_requests: [@analytics::ReportRequest.new(
        view_id: @view_id,
        metrics: [metric],
        date_ranges: [date_range],
        dimensions: [dimension],
        order_bys: [order_by],
      )]
    )
    response = @client.batch_get_reports(request)
    data = response.reports.first.data
    return {
      total: data.totals.first.values.first,
      pages: data.rows.map do |row|
        {
          url: row.dimensions.first,
          views: row.metrics.first.values.first
        }
      end
    }
  end

  private

    #
    # GoogleアナリティクスAPIに認証する
    #
    def auth
      scope = ['https://www.googleapis.com/auth/analytics.readonly']
      @client = @analytics::AnalyticsReportingService.new
      @client.authorization = Google::Auth::ServiceAccountCredentials.make_creds(
        json_key_io: File.open('google_analytics_auth.json'),
        scope: scope
      )
    end

end
