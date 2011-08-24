module ApplicationHelper
  require 'twitter'

  def nav_issues
    @nav_issues ||= Issue.order('id DESC')
  end

  def clippy(text, bgcolor='#FFFFFF')
    html = <<-EOF
    <object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000"
            width="110"
            height="14"
            id="clippy" >
    <param name="movie" value="/assets/clippy.swf"/>
    <param name="allowScriptAccess" value="always" />
    <param name="quality" value="high" />
    <param name="scale" value="noscale" />
    <param NAME="FlashVars" value="text=#{text}&label=#{t("petition_show.click_to_copy")}&feedback=#{t("petition_show.copied")}" />
    <param name="bgcolor" value="#{bgcolor}" />
    <embed src="/assets/clippy.swf"
           width="110"
           height="14"
           name="clippy"
           quality="high"
           allowScriptAccess="always"
           type="application/x-shockwave-flash"
           pluginspage="http://www.macromedia.com/go/getflashplayer"
           FlashVars="text=#{text}&label=#{t("petition_show.click_to_copy")}&feedback=#{t("petition_show.copied")}"
           bgcolor="#{bgcolor}"
    />
    </object>
    EOF
  end

  def meu_rio_tweets
    Rails.cache.fetch("tweets", :expires_in => 15.minutes) do
      result = Twitter.user_timeline('hipsterhacker').first
    end
  end

end
