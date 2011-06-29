package MT::Plugin::AutoThumbnail;

use strict;
use base qw( MT::Plugin );

use MT::Blog;
use MT::Image;
use Image::Size;
use MT::Util qw( encode_url );
use File::Basename;

my $plugin = MT::Plugin::AutoThumbnail->new({
	id 			=>	'autothumbnail',
	key			=>	__PACKAGE__,
	name		=>	'AutoThumbnail',
	l10n_class	=>	'AutoThumbnail::L10N',
	version		=>	'0.1.1',
	description	=>	'<__trans phrase="Description">',
	author_name	=>	'dreamseeker',
	author_link	=>	'http://d-s-b.jp/',
#	plugin_link	=>	'http://d-s-b.jp/',
#	doc_link	=>	'http://d-s-b.jp/',
	icon		=>	'images/icon.gif',
	system_config_template	=>	'autothumbnail_config.tmpl',
	blog_config_template	=>	'autothumbnail_config_blog.tmpl',
	settings	=> new MT::PluginSettings([
		['default_option1', { Default => 'Width, 400, 0' }],
		['default_option2', { Default => '' }],
		['default_option3', { Default => '' }],
		['default_option4', { Default => '', Scope => 'system' }],
	]),
});

MT->add_plugin($plugin);

################################################# REGISTRY

sub init_registry {
	my $plugin = shift;
	$plugin->registry({
		callbacks	=>	{
			'cms_post_save.asset'
				=>	\&_cb_cms_post_save_asset,
			'MT::App::CMS::template_param.header',
				=> \&_cb_tp_header,
		}
	});
}

################################################# CALLBACK

sub _cb_cms_post_save_asset {
	my ($cb, $app, $obj) = @_;
	my $asset_class	=	$obj->class;

	if ($asset_class == 'image') {
		my $blog_id		=	$obj->blog_id;
		my $blog		=	MT::Blog->load($blog_id);
		my $site_path	=	$blog->site_path;
		my $site_url	=	$blog->site_url;

		my $file_path	=	$obj->file_path;
		my $file_name	=	$obj->label;
		my $file_ext	=	$obj->file_ext;

		my @options = ();
		for( my $i=1; $i<=3; $i++ ) {
			my $option = $plugin->get_config_value('default_option'.$i, 'blog:'.$blog_id);
			if($option) { @options[$i-1] = $option; }
		}
		my $alt_suffix = $plugin->get_config_value('default_option4', 'system');

		for( my $i=0; $i<=$#options; $i++ ) {
			create_thumbnail_img( $i, $site_path, $site_url, $file_path, $file_name, $file_ext, @options[$i], $alt_suffix );
		}
	}
}

sub _cb_tp_header {
	my ( $cb, $app, $param, $tmpl ) = @_;
	my $blog_id = $app->param('blog_id');

	for( my $i=1; $i<=4; $i++ ) {
		if($i == 4) { $blog_id = 0; }
		$$param{ 'default_option'.$i } = $plugin->get_config_value('default_option'.$i, 'blog:'.$blog_id);
	}
1;
}

################################################# MAIN

sub create_thumbnail_img {
	my ($i, $site_path, $site_url, $file_path, $file_name, $file_ext, $options, $suffix_str) = @_;
	my $recent_cnt = $i + 1;
	my $img_path = $file_path;
	my @options = split(/,/, $options);
	my $thumb_type = @options[0];
	my $max_size = @options[1];
	my $square = @options[2];

	if(!( -f $img_path ) && ( -f url_decode($img_path) )) {
		$img_path = url_decode($img_path);
	}

	my ($w, $h) = imgsize($img_path);
	my $img = new MT::Image(Filename => $img_path);

	if ( (($thumb_type eq "Width") && ($w > $max_size)) || (($thumb_type eq "Height") && ($h > $max_size)) ) {
		if ($square == 1) {
			(undef, $w, $h) = $img->make_square()
				or update_log(MT::Image->errstr);
		}

		my ($thumb_image, $thumb_w, $thumb_h) = $img->scale( ($thumb_type) => $max_size )
			or update_log(MT::Image->errstr);

		my $_file_name = $file_name;
		my $_file_ext = $file_ext;
		$_file_name =~ s/\.$_file_ext$//;

		my $thumb_suffix = (($suffix_str) ? $suffix_str : $thumb_w . "x" . $thumb_h);
		if( $suffix_str && ($i >= 1) ){ $thumb_suffix .= $i; }

		my $img_thumb_path = get_dir($img_path) . $_file_name . "_" . $thumb_suffix . "." . $_file_ext;

		open FH, ">$img_thumb_path";
		binmode FH;
		print FH $thumb_image;
		close FH;
	}

	return;
}

################################################# SUB

sub url_decode {
	my ($str) = @_;
	$str =~ tr/+/ /;
	$str =~ s/%([0-9A-Fa-f][0-9A-Fa-f])/pack('H2', $1)/eg;
	return $str;
}

sub get_dir {
	my $fullname = shift;
	my ($filename, $dir, $suffix) = fileparse($fullname);
	return $dir;
}

################################################# LOG

sub	update_log {
	my ($msg) = @_; 
	return unless defined($msg);

	use MT::Log;
	my $log = MT::Log->new;
	$log->message($msg) ;
	$log->save or die $log->errstr;
}

1;