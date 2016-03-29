4.8.0
-----
Adds the new public API, beginning with the `be_up` matcher.

4.7.0
-----
Reduced the RSpec dependencies to rspec-core and rspec-expectations.

4.6.0
-----
Added `# frozen_string_literal: true` to all ruby files using `rubocop -a`,
in order to prepare for Ruby 3, and to reduce memory use.

4.5.0
-----
Removed the Excon dependency entirely.

4.4.3
-----
Changed the Google PageSpeed Insights threshold to 85, the value for
"performing well": https://developers.google.com/speed/docs/insights/about

4.4.2
-----
Bug fix for `http://cars.com`. Using net-http now for most operations. Excon
would return a redirect to `https://cars.com:80`, which would lock up and never
return. Not sure what exactly triggered this, but switching adapters solved it.

4.4.1
-----
Reduced the timeouts to 5 seconds.

4.4.0
-----
Support for hosts which don't allow the `HEAD` method. This seems to be the case
with some Google App Engine apps.
