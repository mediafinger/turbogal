require "rails_helper"

# TODO: test for i18n / error messages in :de ?

describe User do
  let(:name)      { "Andy" }
  let(:email)     { "andy@example.com" }
  let(:password)  { "1234" }

  describe "new" do
    context "when the data is valid" do
      it "returns a user" do
        user = User.new(name: name, email: email, password: password, password_confirmation: password)

        expect(user.save!).to be true
        expect(user.class).to eq User
      end
    end

    context "on name validation" do
      it "returns an error when the given name is too short" do
        user = User.new(name: "af", email: email, password: password, password_confirmation: password)
        user.valid?

        expect(user.errors[:name]).to eq ["is too short (minimum is 3 characters)"]
      end
    end

    context "on email validation" do
      it "returns an error when no email is given" do
        user = User.new(name: "atf", password: password, password_confirmation: password)
        user.valid?

        expect(user.errors[:email]).to eq ["can't be blank", "is invalid"]
      end

      it "returns an error when the email is not valid" do
        user = User.new(name: "atf", email: "not-an-email.com", password: password, password_confirmation: password)
        user.valid?

        expect(user.errors[:email]).to eq ["is invalid"]
      end

      it "returns an error when the email is not valid" do
        user = User.new(name: "atf", email: "@.com", password: password, password_confirmation: password)
        user.valid?

        expect(user.errors[:email]).to eq ["is invalid"]
      end
    end

    context "on password validation" do
      it "returns an error when no password is given" do
        user = User.new(name: "atf", email: email)
        user.valid?

        expect(user.errors[:password]).to eq ["is too short (minimum is 4 characters)"]
      end

      it "returns an error when the password is not valid" do
        user = User.new(name: "atf", email: email, password: "abc", password_confirmation: "abc")
        user.valid?

        expect(user.errors[:password]).to eq ["is too short (minimum is 4 characters)"]
      end

      it "returns an error when the password confirmation does not match" do
        user = User.new(name: "atf", email: email, password: password, password_confirmation: "something")
        user.valid?

        expect(user.errors[:password_confirmation]).to eq ["doesn't match Password"]
      end
    end
  end

  describe "update" do
    let(:user) { User.create(name: name, email: email, password: password, password_confirmation: password) }

    context "when the data is valid" do
      it "updates the name" do
        expect(user.update(name: "Andreas")).to eq true
      end

      it "updates the email" do
        expect(user.update(email: "andreas@example.com")).to eq true
      end

      it "updates the password" do
        expect(user.update(password: "passwort", password_confirmation: "passwort")).to eq true
      end

      it "updates the password without checking its length" do
        expect(user.update(password: "X", password_confirmation: "X")).to eq true
      end
    end

    context "when the data is not valid" do
      it "returns an error when the name is not valid" do
        expect(user.update(name: "X")).to eq false
        expect(user.errors[:name]).to eq ["is too short (minimum is 3 characters)"]
      end

      it "returns an error when the email is not valid" do
        expect(user.update(email: "@andreas(ad)example.com")).to eq false
        expect(user.errors[:email]).to eq ["is invalid"]
      end

      it "returns an error when the password_confirmation is not valid" do
        expect(user.update(password: "abc")).to eq false
        expect(user.errors[:password_confirmation]).to eq ["doesn't match Password"]
      end

      it "returns an error when the password_confirmation is not valid" do
        expect(user.update(password: "abc", password_confirmation: "abcdefg")).to eq false
        expect(user.errors[:password_confirmation]).to eq ["doesn't match Password"]
      end
    end
  end

  # authenticate is included through has_secure_password
  describe "authenticate" do
    let!(:user) { User.create(name: name, email: email, password: password, password_confirmation: password) }

    it "returns the user when the correct password is given" do
      authenticated = User.find_by(email: email).try(:authenticate, password)

      expect(authenticated).to eq user
    end

    it "returns false when the wrong password is given" do
      authenticated = User.find_by(email: email).try(:authenticate, "wrong")

      expect(authenticated).to eq false
    end
  end

  describe "confirmed?" do
    let(:user) { User.create(name: name, email: email, password: password, password_confirmation: password) }

    it "is false by default" do
      expect(user.confirmed?).to eq false
    end
  end

  describe "confirmed!" do
    context "when the data is valid" do
      let(:user) { User.create(name: name, email: email, password: password, password_confirmation: password) }

      it "sets confirmed to true" do
        user.confirm!
        expect(user.confirmed?).to eq true
      end
    end

    context "when the data is not valid" do
      let(:user) { User.create(name: "x", email: email, password: password, password_confirmation: password) }

      it "does not set confirmed to true" do
        user.confirm!
        expect(user.confirmed?).to eq false
      end
    end
  end
end
