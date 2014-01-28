require 'test_helper'

class DataControllerTest < ActionController::TestCase
  setup do
    @datum = data(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:data)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create datum" do
    assert_difference('Datum.count') do
      post :create, datum: {  }
    end

    assert_redirected_to datum_path(assigns(:datum))
  end

  test "should show datum" do
    get :show, id: @datum
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @datum
    assert_response :success
  end

  test "should update datum" do
    patch :update, id: @datum, datum: {  }
    assert_redirected_to datum_path(assigns(:datum))
  end

  test "should destroy datum" do
    assert_difference('Datum.count', -1) do
      delete :destroy, id: @datum
    end

    assert_redirected_to data_path
  end
end
