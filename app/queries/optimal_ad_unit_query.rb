# frozen_string_literal: true

class OptimalAdUnitQuery
  def initialize(ad_units, duration_time)
    @ad_units = ad_units
    @duration_time = duration_time
  end

  def call
    # 過濾掉時間不符合的 ad_units
    scheduled_ad_units = @ad_units.select { |ad_unit| ad_unit.on_scheduled?(@duration_time) }
    # 找到每個 ad_units 的最佳 deal
    ad_units_with_best_deal = scheduled_ad_units.map do |ad_unit|
      {
        ad_unit: ad_unit,
        deal: ad_unit.best_deal
      }
    end

    # 比較每個最佳 deal，取得 deal 最佳的 ad_unit
    sorted_ad_units = ad_units_with_best_deal.sort do |ad_unit_a, ad_unit_b|
      # 都有 best_deal，則比較 sorting value 值比較大的優先
      if ad_unit_a[:deal] && ad_unit_b[:deal]
        # 由大排到小 i.e [[-2, 10], [-3, 20],[-1, 30]] => [[-1, 10], [-2, 20], [-3, 30]]
        ad_unit_b[:deal].rank_value <=> ad_unit_a[:deal].rank_value
      elsif ad_unit_a[:deal]
        -1
      elsif ad_unit_b[:deal]
        1
      else
        0
      end
    end


    sorted_ad_units&.first&.dig(:ad_unit)
  end
end
