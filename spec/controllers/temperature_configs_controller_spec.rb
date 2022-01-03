require 'rails_helper'

RSpec.describe TemperatureConfigsController, :type => :controller do
  before :each do
    TemperatureConfig.create(key: 'cold', min: -40, max: 10, description: 'Cold range config')
    TemperatureConfig.create(key: 'warm', min: 10, max: 30, description: 'Warm range config')
    TemperatureConfig.create(key: 'hot', min: 30, max: 99, description: 'Hot range config')
  end

  context 'index' do
    subject { get :index }

    
    it {is_expected.to have_http_status(:ok)}
    
    it "assigns @configs" do
      subject
      expect(assigns(:configs)).to eq(TemperatureConfig.all)
    end
  end

  context 'new' do
    subject { get :new }

    it {is_expected.to have_http_status(:ok)}
    it {is_expected.to render_template(:new)}

    it "assigns @config with new object" do
      expect(TemperatureConfig).to receive(:new)
      subject
    end
  end

  context 'create' do
    subject { post :create, params: params }

    context 'valid' do
      let(:params) {
        {
          temperature_config: {
            key: "really cold",
            min: -50,
            max: 0,
            description: "some desc here"
          }
        }
      }

      it {is_expected.to have_http_status(302)}
      it {is_expected.to redirect_to(:temperature_configs)}

      it 'increases config db entries number' do
        expect{subject}.to change{TemperatureConfig.count}.by(1)
      end

      it 'adds config entry with corect values' do
        subject
        expect(TemperatureConfig.last.key).to eq(params[:temperature_config][:key])
        expect(TemperatureConfig.last.min).to eq(params[:temperature_config][:min])
        expect(TemperatureConfig.last.max).to eq(params[:temperature_config][:max])
        expect(TemperatureConfig.last.description).to eq(params[:temperature_config][:description])
      end
    end

    context "invalid - max < min" do
      let(:params) {
        {
          temperature_config: {
            key: "other",
            min: 0,
            max: -10,
            description: "some desc here"
          }
        }
      }
      it {is_expected.to have_http_status(:unprocessable_entity)}
      it {is_expected.to render_template(:new)}

      it 'doesnt add any config db entries' do
        expect{subject}.not_to change{TemperatureConfig.count}
      end
    end
  end

  context 'edit' do
    subject { get :edit, params: { id: TemperatureConfig.last.id }}

    it {is_expected.to have_http_status(:ok)}
    it {is_expected.to render_template(:edit)}

    it "assigns @config with the corect object" do
      subject
      expect(assigns(:config)).to eq(TemperatureConfig.last)
    end

  end

  context 'update' do
    subject { put :update, params: params }
    let(:config) { TemperatureConfig.last }

    context 'invalid' do
      let(:params) {
        {
          id: config.id,
          temperature_config: {
            key: nil,
            min: 20,
            max: 30,
            description: "some desc here"
          }
        }
      }

      it {is_expected.to have_http_status(:unprocessable_entity)}

      it {is_expected.to render_template(:edit)}
    end

    context 'valid' do
      let(:params) {
        {
          id: config.id,
          temperature_config: {
            key: "other",
            min: 20,
            max: 30,
            description: "some desc here"
          }
        }
      }

      it {is_expected.to redirect_to(:temperature_configs)}

      it 'updates key' do
        expect{subject}.to change{config.reload.key}.from("hot").to(params[:temperature_config][:key])
      end

      it 'updates min' do
        expect{subject}.to change{config.reload.min}.from(30).to(params[:temperature_config][:min])
      end

      it 'updates max' do
        expect{subject}.to change{config.reload.max}.from(99).to(params[:temperature_config][:max])
      end

      it 'updates description' do
        expect{subject}.to change{config.reload.description}.from('Hot range config').to(params[:temperature_config][:description])
      end
    end
  end

  context 'delete' do
    subject { delete :destroy, params: { id: TemperatureConfig.last.id }}

    it {is_expected.to redirect_to(:temperature_configs)}

    it 'removes config element' do
      expect{subject}.to change{TemperatureConfig.count}.by(-1)
    end
  end

end