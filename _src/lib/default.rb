# All files in the 'lib' directory will be loaded before nanoc starts compiling.

require 'time'
include Nanoc3::Helpers::Blogging
include Nanoc3::Helpers::Breadcrumbs
include Nanoc3::Helpers::LinkTo
include Nanoc3::Helpers::Rendering
include Nanoc3::Helpers::Tagging
include Nanoc3::Helpers::Text
include Nanoc3::Helpers::XMLSitemap

# Hyphens are converted to sub-directories in the output folder.
#
# If a file has two extensions like Rails naming conventions, then the first extension
# is used as part of the output file.
#
#   sitemap.xml.erb # => sitemap.xml
#
# If the output file does not end with an .html extension, item[:layout] is set to 'none'
# bypassing the use of layouts.
#
def route_path( item )
	url = item[:content_filename].gsub( /^content/, '' )

	# determine output extension
	extname = '.' + item[:extension].split( '.' ).last
	outext = ''
	if not item[:kind] == 'article' and url.match( /(\.[a-zA-Z0-9]+){2}$/ ) # => *.html.erb, *.html.md ...
		outext = '' # remove 2nd extension
	elsif extname == ".sass"
		outext = '.css'
	else
		outext = '.html'
	end
	url.gsub!( extname, outext )

	if item[:kind] == 'article' and url =~ /^\/news\// then
		# /2010/01-02-some-title.html -> /2010/01/02/some-title.html
		url = url.match( /^(\/news)\/(\d+)[\/\-](\d+)[\/\-](\d+)[\/\-](.+)$/ ).captures.join( '/' )
	end

	url
end

# Helper function to create nav list items in header.haml
def nav_item( title, url, pattern = nil )
	isCurrent = pattern ? @item_rep.path =~ pattern : @item_rep.path.include?( url )
	res = "<li><a href='#{url}'>#{title}</a>"
	res += "<div id='selected'><div id='text'>#{title}</div></div>" if isCurrent
	res += "</li>"
end

# Helper function to get a list of articles with a given tag and sort by date
def sorted_articles_with_tag( tag )
	items = items_with_tag( tag )
	items.sort!{ |a, b| b[:created_at] <=> a[:created_at] }
end

# Helper function to generate the 'meta' part of an article
def article_meta( article )
	"<p class='meta'>by Thiago Bastos on " + Time.parse( article[:created_at] ).strftime( "%B %e, %Y" ) + "</p>"
end

# Helper function to generate the 'tags' part of an article
def article_tags( article )
	"<p class='tags'>Tagged as: " + tags_for( article, :base_url => @config[:base_url] + '/tags/' ) + "</p>"
end

# Helper function to generate download links for a release
def download_links( project, version )
	link_to( "TAR", "https://github.com/libcoral/#{project}/tarball/#{version}" ) + ", " +
	link_to( "ZIP", "https://github.com/libcoral/#{project}/zipball/#{version}" )
end
