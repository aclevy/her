# Upgrade Her

Here is a list of backward-incompatible changes that were introduced while Her is pre-1.0. After reaching 1.0, it will follow the [Semantic Versioning](http://semver.org/) system.

## 0.5

* Her is now compatible with `ActiveModel` and includes `ActiveModel::Validations`.

  Before 0.5, the `errors` method on an object would return an error list received from the server (the `:errors` key defined by the parsing middleware). But now, `errors` returns the error list generated after calling the `valid?` method (or any other similar validation method from `ActiveModel::Validations`). The error list returned from the server is now accessible from the `server_errors` method.

## 0.2.4

* Her no longer includes default middleware when making HTTP requests. The user has now to define all the needed middleware. Before:

        Her::API.setup :url => "https://api.example.com" do |connection|
          connection.insert(0, FaradayMiddle::OAuth)
        end

  Now:

        Her::API.setup :url => "https://api.example.com" do |connection|
          connection.use FaradayMiddle::OAuth
          connection.use Her::Middleware::FirstLevelParseJSON
          connection.use Faraday::Request::UrlEncoded
          connection.use Faraday::Adapter::NetHttp
        end

## 0.2

* The default parser middleware has been replaced to treat first-level JSON data as the resource or collection data. Before it expected this:

        { "data": { "id": 1, "name": "Foo" }, "errors": [] }

   Now it expects this (the `errors` key is not treated as resource data):

        { "id": 1, "name": "Foo", "errors": [] }

   If you still want to get the old behavior, you can use `Her::Middleware::SecondLevelParseJSON` instead of `Her::Middleware::FirstLevelParseJSON` in your middleware stack.
