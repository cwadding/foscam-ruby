require 'spec_helper'

describe Foscam::Model::Msn do
  before(:each) do
    @msn = Foscam::Model::Msn.new(:user=>"", :pwd=>"", :friend1=>"", :friend2=>"", :friend3=>"", :friend4=>"", :friend5=>"", :friend6=>"", :friend7=>"", :friend8=>"", :friend9=>"", :friend10=>"")
  end
  
  it "sets string fields" do
    [:user, :pwd].each do |method|
      @msn.send(method).should be_a_kind_of(String)
    end
  end
  it "sets friends fields" do
    [:friend1, :friend2, :friend3, :friend4, :friend5, :friend6, :friend7, :friend8, :friend9, :friend10].each do |method|
      @msn.send(method).should be_a_kind_of(String)
    end
  end
end