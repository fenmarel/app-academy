require 'spec_helper'

describe LinkSub do

  describe "associations" do
    it { should belong_to :link }
    it { should belong_to :sub }
  end
end
