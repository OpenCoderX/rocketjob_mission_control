module RocketJobMissionControl
  module JobsHelper
    STATE_ICON_MAP = {
      queued:    'fa-inbox',
      paused:    'fa-pause',
      running:   'fa-play',
      completed: 'fa-check',
      aborted:   'fa-stop',
      failed:    'fa-exclamation-triangle',
      scheduled: 'fa-clock-o',
      enabled:   'fa-check',
      disabled:  'fa-stop'
    }

    def job_state_icon(state)
      STATE_ICON_MAP[state.to_sym] + ' ' + state.to_s
    end

    def job_icon(job)
      # TODO move this logic to RocketJob::Job
      state =
        if job.queued? && job.run_at && (job.run_at > Time.now)
          :scheduled
        else
          job.state
        end
      job_state_icon(state)
    end

    def job_duration(job)
      started_at = job.started_at   || Time.now
      time_to    = job.completed_at || Time.now
      distance_of_time_in_words(started_at, time_to, highest_measure_only: true, include_seconds: true)
    end

    def job_states
      @job_states ||= RocketJob::Job.aasm.states.collect { |state| state.name.to_s }
    end

    def pretty_print_array_or_hash(arguments)
      return arguments unless arguments.kind_of?(Array) || arguments.kind_of?(Hash)
      json_string_options = { space: ' ', indent: '  ', array_nl: '<br />', object_nl: '<br />' }
      JSON.generate(arguments, json_string_options).html_safe
    end

    def job_selected_class(job, selected_job)
      if selected_job.present? && job.id == selected_job.id
        'selected'
      else
        ''
      end
    end

    def job_title(job)
      perform_method = job.perform_method == :perform ? '' : "##{job.perform_method}"
      "#{job.class.name}#{perform_method}"
    end
  end
end
