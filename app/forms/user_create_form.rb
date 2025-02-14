# frozen_string_literal: true

  class UserCreateForm < BaseForm
    # permit_params .............................................................
    PERMIT_PARAMS = [
      :name,
      :mobile,
      :mobile_code, # 電話驗證碼
      :password,
      :password_confirmation,
      :promoter_code,
    ]
    # attr ......................................................................
    attr_reader *PERMIT_PARAMS

    # validates .................................................................
    before_validation :format_value
    before_validation :copy_nick_name

    validates :name, :mobile_code, presence: true
    validates :mobile,
      presence: true,
      length: { is: 10 },
      format: { with: /\A09[0-9]{8}\z/, message: "請輸入正確格式的電話號碼：09xx xxx xxx" }

    validates :password, :password_confirmation, length: { minimum: 8 }
    validate :check_password_confirmation

    validate :check_promoter, if: -> { @promoter_code.present? }

    def initialize(params)
      init_form(nil, params)

    end

    def save
      return false unless valid?
      return false unless mobile_unused?
      return false unless mobile_code_valid?

      @user.name = @name
      @user.mobile = @mobile
      @user.mobile_confirm_at = Time.now
      @user.password = @password
      @user.password_confirmation = @password_confirmation

      @user.promoter = @promoter
      @user.company = @promoter&.company

      @user.save!
      @user.authorize!

      true
    rescue ActiveRecord::RecordInvalid
      self.errors.merge! @user.errors
      false
    end

    private

    def format_value
      @name = @name.to_s.strip
      @mobile = @mobile.to_s&.gsub(/\D/, "")
    end

    def copy_nick_name
      @nickname = @name if @nickname.blank?
    end

    def check_password_confirmation
      if @password != @password_confirmation
        errors.add(:password_confirmation, "密碼不一致，請重新確認！")
      end
    end

    def check_promoter
      if @promoter.nil?
        errors.add(:promoter_code, "找不到此推薦好友！")
      end
    end

    def mobile_unused?
      return true if @user.mobile == @mobile

      if User.where(mobile: @mobile).count > 0
        errors.add(:mobile, "此電話號碼已註冊使用！")
        return false
      end

      true
    end

    def mobile_code_valid?
      unless CodeValidationHistory.current_code_equal?(:mobile_verify, @mobile, @mobile_code)
        errors.add(:mobile_code, "驗證碼不正確！")
        return false
      end

      true
    end
  end
