
# Sidekiq-POC
This is a Proof Of Concept to show how the free version of [Sidekiq](https://github.com/mperham/sidekiq) can:

 1. Run process in background.
 2. To be able to track the progress in a Web UI.
 3. To be able to cancel a running job.
 4. Set a concurrency and threshold throttling for Sidekiq.
 5. Run process in batches.
 6. Set callbacks for the jobs.
 7. Use cron jobs with Sidekiq.

![POC](https://media.giphy.com/media/FSBbRZEpPxJbaHcyvJ/giphy.gif)
---

## Requirements

* Ruby 2.7.0
* Rails 6.1.0
* Redis
* PostgreSQL 13.1

## Available Workers

#### SidekiqTestWorker

 This is the main worker that will be used for our test.
 Here you can:

  - Limit the concurrent jobs and the threshold of this class.
 - See the progress of the job in the Web UI.
 - Cancel the running job.

To set the concurrency and the threshold you should change `sidekiq_throttle` configuration:
```Ruby
sidekiq_throttle({
                     # Allow maximum 2 concurrent jobs of this class at a time.
                     concurrency: { limit: 2 },
                     # Allow maximum 1K jobs being processed within one hour window.
                     threshold: { limit: 1_000, period: 1.hour }
                   })
```

You can run this worker using:
```Ruby
pid = SidekiqTestWorker.perform_async
```

To cancel the execution of a job you can use:
```Ruby
SidekiqTestWorker.cancel!(pid)
```

#
#### BatchWorker

This is the worker to test the batch execution and callbacks.
 Here you can:

 - Execute many process in batches.
 - Check the callback when the job complete the execution.

You can run this worker using:
```Ruby
BatchWorker.perform_async
```
#
#### PrintWorker

This is the worker used by the `BatchWorker` to print the objects.

#
#### BaseWorker

This is the base worker to be inherited by the other workers.
We set all common imports and methods here.

## Running the project
First you will need to start the Rails server using:
```bash
rails s
```
After that, you will run the Sidekiq server on another terminal using:
```bash
sidekiq
```
You can check the Sidekiq Web UI accessing this URL:
```http
http://localhost:3000/sidekiq/
```

## Cron jobs
We are using the [Whenever gem](https://github.com/javan/whenever) to set our cron jobs.
Please follow the instructions on their [page](https://github.com/javan/whenever) for the setup.
