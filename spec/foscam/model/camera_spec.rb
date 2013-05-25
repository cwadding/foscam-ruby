require 'spec_helper'

describe Foscam::Model::Camera do
  before(:each) do
    @camera = Foscam::Model::Camera.new({:resolution=>"8", :brightness=>"169", :contrast=>"2", :mode=>"1", :flip=>"0", :fps=>"0"})
  end
  it "sets the mode as a string" do
  	@camera.mode.should be_a_kind_of(String)
  	Foscam::Model::Camera::CAMERA_PARAMS_MODE.values.should include(@camera.mode)
  end

  it "sets the orientation as a string" do
  	@camera.orientation.should be_a_kind_of(String)
  	Foscam::Model::Camera::CAMERA_PARAMS_ORIENTATION.values.should include(@camera.orientation)
  end

  it "sets the resolution as a string" do
  	@camera.resolution.should be_a_kind_of(String)
  	Foscam::Model::Camera::CAMERA_PARAMS_RESOLUTION.values.should include(@camera.resolution)
  end

  it "sets the brightness as a number" do
  	@camera.brightness.should be_a_kind_of(Integer)
  end
  it "sets the contrast as a number" do
  	@camera.contrast.should be_a_kind_of(Integer)
  end
end