require 'spec_helper'
require_relative '../../lib/api'

describe Squid::Api do

  def app
    Squid::Api
  end

  describe 'POST /test-suite-started' do

    let(:data) {
      OpenStruct.new(
        build_id:   1,
        started_at: Time.now
      )
    }

    it 'creates a new Build' do
      post '/test-suite-started', data.to_h.to_json

      expect(last_response).to be_ok

      expect(Build.count).to eq(1)

      last_build = Build.last
      expect(last_build.build_id).to eq(data.build_id)
      expect(last_build.started_at.to_i).to eq(data.started_at.to_i)
    end
  end

  describe 'POST /test-suite-finished' do
    before do
      Build.create(
        build_id:   1,
        started_at: Time.new(2025, 11, 27, 10, 30, 22)
      )
    end

    let(:data) {
      OpenStruct.new(
        build_id:      1,
        status:        'failed',
        passed_count:  8,
        failed_count:  1,
        pending_count: 1,
        total_count:   10,
        duration:      0.213,
        started_at:    Time.new(2025, 11, 27, 10, 30, 23),
        finished_at:   Time.new(2025, 11, 27, 10, 30, 24)
      )
    }

    it 'updates the Build' do
      post '/test-suite-finished', data.to_h.to_json

      expect(last_response).to be_ok

      expect(Build.count).to eq(1)

      last_build = Build.last
      expect(last_build.build_id).to eq(data.build_id)
      expect(last_build.status).to eq(data.status)

      expect(last_build.passed_count).to eq(data.passed_count)
      expect(last_build.failed_count).to eq(data.failed_count)
      expect(last_build.pending_count).to eq(data.pending_count)
      expect(last_build.total_count).to eq(data.total_count)

      expect(last_build.duration).to eq(data.duration)
      expect(last_build.started_at.to_i).to eq(data.started_at.to_i)
      expect(last_build.finished_at.to_i).to eq(data.finished_at.to_i)
    end
  end

  %w[passed failed pending].each do |status|
    describe "POST /test-#{status}" do
      before do
        Build.create(
          build_id:   1,
          started_at: Time.new(2025, 11, 27, 10, 30, 22)
        )
      end

      let(:data) {
        OpenStruct.new(
          build_id:    1,
          test_group:  'helper',
          description: ['SomeHelper',
                        '#whatever',
                        'returns some data'].join('<<<|>>>'),
          runtime:     0.213,
          started_at:  Time.new(2025, 11, 27, 10, 30, 23),
          finished_at: Time.new(2025, 11, 27, 10, 30, 24)
        )
      }

      it 'creates a new Build' do
        post "/test-#{status}", data.to_h.to_json

        expect(last_response).to be_ok

        expect(Test.count).to eq(1)

        last_test = Test.last
        expect(last_test.build_id).to eq(data.build_id)
        expect(last_test.test_group).to eq(data.test_group)
        expect(last_test.description).to eq(data.description)

        expect(last_test.runtime).to eq(data.runtime)
        expect(last_test.started_at.to_i).to eq(data.started_at.to_i)
        expect(last_test.finished_at.to_i).to eq(data.finished_at.to_i)
      end

      it 'increments the Build count' do
        post "/test-#{status}", data.to_h.to_json

        expect(last_response).to be_ok

        last_build = Build.last
        expect(last_build["#{status}_count"]).to eq(1)
      end
    end
  end

end
