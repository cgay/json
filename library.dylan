module: dylan-user

define library json
  use common-dylan;
  use io, import: { format, streams };
  use strings;

  export json;
end library json;

define module json
  use common-dylan;
  use streams, import: { read-to-end, write };
  use strings, import: { decimal-digit?, replace-substrings };
  use format, import: { format-to-string };

  export
    encode-json,
    parse-json,
    <json-error>,
    $null;
end module json;
