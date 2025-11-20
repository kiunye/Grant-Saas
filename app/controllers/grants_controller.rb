class GrantsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_generation_limit, only: [:step1, :generate]

  def step1
    session[:grant_form] ||= {}
  end

  def save_step1
    session[:grant_form] ||= {}
    session[:grant_form][:step1] = step1_params.to_h
    redirect_to step2_grants_path
  end

  def step2
    redirect_to step1_grants_path unless session[:grant_form]&.dig(:step1)
  end

  def save_step2
    session[:grant_form][:step2] = step2_params.to_h
    redirect_to step3_grants_path
  end

  def step3
    redirect_to step1_grants_path unless session[:grant_form]&.dig(:step2)
  end

  def generate
    unless current_user.can_generate?
      flash[:alert] = 'You have reached your generation limit for this month'
      return redirect_to user_dashboard_path
    end

    session[:grant_form][:step3] = step3_params.to_h
    
    # Generate document using OpenAI
    result = OpenaiService.new(session[:grant_form]).generate_grant_document
    
    if result[:success]
      # Create document
      document = current_user.documents.create!(
        title: session[:grant_form][:step1][:project_title] || 'Grant Proposal',
        content: result[:content],
        form_data: session[:grant_form],
        status: 'completed'
      )

      # Log usage
      current_user.usage_logs.create!(action: 'generate')

      # Clear session
      session[:grant_form] = nil

      flash[:notice] = 'Grant document generated successfully!'
      redirect_to document
    else
      flash[:alert] = "Failed to generate document: #{result[:error]}"
      render :step3
    end
  end

  private

  def check_generation_limit
    unless current_user.can_generate?
      flash[:alert] = 'You have reached your generation limit. Please upgrade your plan.'
      redirect_to subscriptions_path
    end
  end

  def step1_params
    params.require(:grant).permit(:project_title, :organization_name, :contact_email, :project_duration)
  end

  def step2_params
    params.require(:grant).permit(:problem_statement, :target_population, :project_goals, :expected_impact)
  end

  def step3_params
    params.require(:grant).permit(:activities, :timeline, :budget_overview, :sustainability_plan)
  end
end
