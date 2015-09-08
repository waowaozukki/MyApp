use File::Spec;
use File::Basename;

print File::Spec->catfile(dirname(__FILE__), 'MyApp', 'lib'), "\n";
