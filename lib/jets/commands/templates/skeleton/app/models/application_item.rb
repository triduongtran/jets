<% if options[:dynamodb] == 'dynomite' -%>
class ApplicationItem < Dynomite::Item
<% else -%>
class ApplicationItem
  include Dynamodbid
<% end -%>
end
