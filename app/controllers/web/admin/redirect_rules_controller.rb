class Web::Admin::RedirectRulesController < Web::Admin::ApplicationController
  def index
    if params[:search]
      redirect_rules = RedirectRule.active.search_everywhere params[:search]
    else
      redirect_rules = RedirectRule.order(id: :desc).send params[:scope]
    end
    @redirect_rules = redirect_rules.page(params[:page]).decorate
  end

  def new
    @redirect_rule_form = pre_build_record RedirectRuleForm.new_with_model
  end

  def edit
    @redirect_rule_form = RedirectRuleForm.find_with_model params[:id]
  end

  def create
    @redirect_rule_form = RedirectRuleForm.new_with_model
    @redirect_rule_form.submit(params[:redirect_rule])
    if @redirect_rule_form.save
      redirect_to admin_redirect_rules_path
    else
      render action: :new
    end
  end

  def update
    @redirect_rule_form = RedirectRuleForm.find_with_model params[:id]
    @redirect_rule_form.submit(params[:redirect_rule])
    if @redirect_rule_form.save
      redirect_to admin_redirect_rules_path
    else
      render action: :edit
    end
  end

  def destroy
    @redirect_rule = RedirectRule.find params[:id]
    @redirect_rule.remove
    redirect_to admin_redirect_rules_path
  end
end
