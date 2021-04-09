class CalendarsController < ApplicationController

  # １週間のカレンダーと予定が表示されるページ
  def index
    get_week
    @plan = Plan.new
  end

  # 予定の保存
  def create
    
    Plan.create(plan_params)
    redirect_to action: :index
  end

  private

  def plan_params
    #Issue4。params.require(:calendars)をparams.require(:plan)に変更
    params.require(:plan).permit(:date, :plan)
  end

  def get_week
    wdays = ['(日)','(月)','(火)','(水)','(木)','(金)','(土)']

    # Dateオブジェクトは、日付を保持しています。下記のように`.today.day`とすると、今日の日付を取得できます。
    @todays_date = Date.today
    # 例)　今日が2月1日の場合・・・ Date.today.day => 1日

    @week_days = []

    plans = Plan.where(date: @todays_date..@todays_date + 6)

    7.times do |x|
      today_plans = []
      plans.each do |plan|
        today_plans.push(plan.plan) if plan.date == @todays_date + x
      end

      wday_num = Date.today.wday + x # wdayメソッドを用いて取得した数値。timesメソッドのブロック変数は繰り返される毎に１ずつ増えていく。と言うことは、Xが勝手に1増えていくと言うこと。
      if wday_num >= 7#「wday_numが7以上の場合」という条件式
        wday_num = wday_num -7
      end

      days = { month: (@todays_date + x).month, date: (@todays_date + x).day, plans: today_plans, wday: wdays[wday_num]}#wdaysから値を取り出す記述。wdays[wday_num(ここは数字であるべき。成立するのはwdayメソッドが配列を整数で抜く特性があって勝手に数字になってるから。)]

      @week_days.push(days)
    end

  end
end




  