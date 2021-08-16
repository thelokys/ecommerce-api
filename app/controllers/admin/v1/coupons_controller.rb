module Admin::V1
  class CouponsController < ApiController

    before_action :load_coupon, only: [:update, :destroy]

    # GET: /admin/v1/coupons
    def index
      @coupons = Coupon.all
    end

    # POST: /admin/v1/coupons
    def create
      @coupon = Coupon.new
      @coupon.attributes = coupon_params
      save_coupon!
    end

    # PATCH: /admin/v1/coupons/:id
    def update
      load_coupon
      @coupon.attributes = coupon_params
      save_coupon!
    end

    # DELETE: /admin/v1/coupons/:id
    def destroy
      load_coupon
      @coupon.destroy!
      rescue
        render_error(fields: @category.errors.messages)
    end

    private
    def load_coupon
      @coupon = Coupon.find(params[:id])
    end

    def coupon_params
      return {} unless params.has_key?(:coupon)
      params.require(:coupon).permit(:code, :status, :discount_value, :due_date)
    end

    def save_coupon!
      @coupon.save!
      render :show
      rescue
        render_error(fields: @coupon.errors.messages)
    end
  end
end