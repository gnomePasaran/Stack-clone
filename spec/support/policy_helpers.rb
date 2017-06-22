module PolicyHelpers
  def it_denies_access
    it "denies access" do
      expect(subject).not_to permit(pundit_user, record)
    end
  end

  def it_grants_access
    it "grants access" do
      expect(subject).to permit(pundit_user, record)
    end
  end
end
