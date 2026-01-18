class Users::InvitationsController < Devise::InvitationsController
  def new
    # 招待ボタンからplan_idが渡された場合、セッションに保存する
    if params[:plan_id]
      session[:invitation_plan_id] = params[:plan_id]
    end
    super
  end

  def create
    # セッションからplan_idを取得（paramsになければ）
    plan_id = params[:plan_id] || session[:invitation_plan_id]

    # 1. 入力されたメールアドレスを取得
    email = params.dig(:user, :email)

    # 2. すでに登録済みのユーザーか確認（招待待ちでないユーザー）
    user = User.find_by(email: email)

    if user && user.invitation_token.nil?
      # --- 登録済みユーザーの場合の処理 ---
      if plan_id.present?
        plan = Plan.find_by(id: plan_id)

        if plan
          if plan.plan_users.exists?(user_id: user.id)
            flash[:alert] = "#{user.nickname || email}さんはすでにメンバーです。"
          else
            plan.plan_users.create(user_id: user.id)
            flash[:notice] = "#{user.nickname || email}さんを旅行に追加しました。"
          end
          redirect_to after_invite_path_for(current_user)
          return
        end
      end
    end

    super do |resource|
      if resource.persisted? && plan_id.present?
        plan = Plan.find_by(id: plan_id)
        if plan && !plan.plan_users.exists?(user_id: resource.id)
          plan.plan_users.create(user_id: resource.id)
        end
      end
    end
  end

  protected

  def after_invite_path_for(resource)
    # セッションからplan_idを取得してリダイレクト先を決定
    plan_id = session.delete(:invitation_plan_id)
    if plan_id
      plan_availabilities_path(plan_id)
    else
      super
    end
  end
end
