class PagesController < ApplicationController
  def home
  end

  def features
    # 홈페이지의 #services 섹션으로 리다이렉트
    redirect_to root_path(anchor: "services")
  end

  def pricing
    # 가격 정보는 뷰에서 직접 정의
  end
end
