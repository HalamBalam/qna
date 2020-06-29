shared_examples_for 'deleting files' do
  scenario 'Unauthenticated user can not delete files', js: true do
    visit path

    within html_class do
      expect(page).to_not have_link 'Delete file'
    end
  end


  scenario 'Authenticated user deletes file from his resource', js: true do
    sign_in resource.user
    visit path

    within html_class do
      expect(page).to have_link 'rails_helper.rb'

      click_on 'Delete file', match: :first 

      expect(page).to_not have_link 'rails_helper.rb' 
    end
  end


  scenario "Authenticated user can not delete a file from another user's resource", js: true do
    sign_in user
    visit path 

    within html_class do
      expect(page).to_not have_link 'Delete file'
    end 
  end
end
