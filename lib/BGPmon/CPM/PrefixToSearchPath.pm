package BGPmon::CPM::PrefixToSearchPath;  

use base qw(BGPmon::CPM::DBObject);

__PACKAGE__->meta->setup
(
  table   => 'search_using',
  columns => [ qw(prefix_dbid search_path_dbid) ],
  pk_columns => ['prefix_dbid', 'search_path_dbid'],

  foreign_keys =>
  [
    prefix =>
    {
      class       => 'BGPmon::CPM::Prefix',
      key_columns => { prefix_dbid => 'dbid' },
    },

    color =>
    {
      class       => 'BGPmon::CPM::SearchPath',
      key_columns => { search_path_dbid => 'dbid' },
    },
  ],
);
