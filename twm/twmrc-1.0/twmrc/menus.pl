#!/usr/bin/perl
# gen.pl
# Generate menus for matt's .twmrc
# $Fuller: myprograms/twmrc/menus.pl,v 1.2 2002/07/08 08:10:57 fullermd Exp $

# Oh boy...  source the massive menu hash
require "menus.hash";

# Start the output file
open(RUNOUT, ">menus.temp");

# Ugly stuff needed for format
select((select(RUNOUT),
	$~ = "RUNOUT",
	)[0]);

# Now that we've loaded this insane hash, process it and
# make the menus section...
foreach $menutomake ( keys %MENUS )
{
	print RUNOUT "menu \"$menutomake\"\n\{\n";
	$menu_title = $MENUS{$menutomake}->{title};
	$entry_name = $menu_title;
	$entry_command = "f.title";
	write RUNOUT;
	@orderlist = split /[\ \t\']+/, $MENUS{$menutomake}->{order};
	foreach $menuentry ( @orderlist )
	{
		if ($menuentry eq 'nop')
		{
			$entry_name = "";
			$entry_command = "f.nop";
			write RUNOUT;
			next;
		}
		$entry_name = $MENUS{$menutomake}->{menuitem}->{$menuentry}->{name};
		$entry_command = $MENUS{$menutomake}->{menuitem}->{$menuentry}->{command};
		write RUNOUT;
	}
	print RUNOUT "\}\n\n";
}

# That should do us
close RUNOUT;
rename("menus.temp", "menus");
exit;


# Gonna make this second field REEEEAL long so I don't have to
# dynamically generate the format, because that'd suck

format RUNOUT =
"@<<<<<<<<<<<<" @<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
$entry_name,     $entry_command
.

