shared_examples_for 'attachable' do
  let!(:file) { create(:attachment, attachable: attachable) }
  
  describe 'DELETE #destroy' do
    it 'deletes files' do
      expect { delete :destroy, params: { id: file, format: :js } }.to change(Attachment, :count).by(-1)
    end
    
    it 'render destroy view' do
      delete :destroy, params: { id: file, format: :js }
      
      expect(response).to render_template :destroy
    end
  end 
end
