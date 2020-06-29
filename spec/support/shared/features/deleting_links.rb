shared_examples_for 'deleting links' do
  given!(:link) { create(:link, linkable: linkable) }

  scenario 'Unauthenticated user can not delete links', js: true do
    visit path

    within html_class do
      expect(page).to_not have_link 'Remove link'
    end
  end


  scenario 'Authenticated user deletes link from his linkable', js: true do
    sign_in linkable.user
    visit path

    within html_class do
      expect(page).to have_link 'Thinknetica'

      click_on 'Remove link' 

      expect(page).to_not have_link 'Thinknetica' 
    end
  end


  scenario "Authenticated user can not delete a link from another user's linkable", js: true do
    sign_in user
    visit path 

    within html_class do
      expect(page).to_not have_link 'Remove link'
    end 
  end
end
