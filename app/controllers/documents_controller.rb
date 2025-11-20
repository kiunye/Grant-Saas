class DocumentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_document, only: [:show, :edit, :update, :destroy, :export_pdf, :export_docx]

  def index
    @documents = current_user.documents.recent
  end

  def show
    # Document details
  end

  def edit
    # Edit document
  end

  def update
    if @document.update(document_params)
      flash[:notice] = 'Document updated successfully'
      redirect_to @document
    else
      flash[:alert] = 'Failed to update document'
      render :edit
    end
  end

  def destroy
    if @document.destroy
      flash[:notice] = 'Document deleted successfully'
    else
      flash[:alert] = 'Failed to delete document'
    end
    redirect_to documents_path
  end

  def export_pdf
    unless current_user.can_export?
      flash[:alert] = 'PDF export is only available on paid plans'
      return redirect_to @document
    end

    result = ExportService.new(@document).to_pdf
    
    if result[:success]
      send_data result[:file], filename: "#{@document.title}.pdf", type: 'application/pdf'
    else
      flash[:alert] = result[:error]
      redirect_to @document
    end
  end

  def export_docx
    unless current_user.can_export?
      flash[:alert] = 'DOCX export is only available on paid plans'
      return redirect_to @document
    end

    result = ExportService.new(@document).to_docx
    
    if result[:success]
      send_data result[:file], filename: "#{@document.title}.docx", 
                type: 'application/vnd.openxmlformats-officedocument.wordprocessingml.document'
    else
      flash[:alert] = result[:error]
      redirect_to @document
    end
  end

  private

  def set_document
    @document = current_user.documents.find(params[:id])
  end

  def document_params
    params.require(:document).permit(:title, :content)
  end
end
