Module: dylan-user
Synopsis: JSON test suite
Author: Carl Gay
Copyright: Copyright (c) 2012 Dylan Hackers.  All rights reserved.
License: See License.txt in this distribution for details.


define library json
  use collections;
  use common-dylan;
  use io, import: { format, streams };
  use strings;
  use system, import: { locators };
  use testworks;

  export json;
end library json;

define module json
  use common-dylan;
  use format, import: { format-to-string };
  use streams, import: { read-to-end, write };
  use strings, import: { decimal-digit?, replace-substrings };
  use locators, import: { <file-locator>, locator-name };
  use table-extensions,
    import: {},
    rename: { table => make-table };
  use testworks;
  export
    encode-json,
    parse-json,
    <json-error>,
    $null;
end module json;
