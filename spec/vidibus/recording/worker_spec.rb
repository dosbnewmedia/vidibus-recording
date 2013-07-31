require 'spec_helper'

describe Vidibus::Recording::Worker do
  let(:recording) do
    Recording.create({
      :name => 'N-TV Live',
      :stream => 'rtmp://fms.rtl.de/ntvlive/livestream/channel1'
    })
  end

  let(:subject) do
    Vidibus::Recording::Worker.new(recording)
  end

  def stub_fork
    pid = 123
    stub(subject).fork do |block|
      block.call
      pid
    end
    mock(Process).detach(pid)
  end

  describe '#start' do
    it 'should fork and detach a separate process' do
      mock(subject).fork {123}
      mock(Process).detach(123)
      subject.start
    end

    context 'with forked process' do
      before do
        stub_fork
      end

      it 'should call #record' do
        mock(subject).record
        subject.start
      end
    end
  end
end