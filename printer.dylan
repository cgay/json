Module: %json
Copyright: Original Code is Copyright (c) 2011 Dylan Hackers
           All rights reserved.
License: See License.txt in this distribution for details.

define open generic encode-json (stream :: <stream>, object :: <object>);

define method encode-json (stream :: <stream>, string :: <string>)
  write-element(stream, '"');
  let zero :: <integer> = as(<integer>, '0');
  let a :: <integer> = as(<integer>, 'a') - 10;
  local
    method write-hex-digit (code :: <integer>)
      write-element(stream, as(<character>,
                               if (code < 10) zero + code else a + code end));
    end,
    method write-unicode-escape (code :: <integer>)
      write(stream, "\\u");
      write-hex-digit(ash(logand(code, #xf000), -12));
      write-hex-digit(ash(logand(code, #x0f00), -8));
      write-hex-digit(ash(logand(code, #x00f0), -4));
      write-hex-digit(logand(code, #x000f));
    end;
  for (char in string)
    let code = as(<integer>, char);
    case
      code <= #x1f =>
        let escape-char = select (char)
                            '\b' => 'b';
                            '\f' => 'f';
                            '\n' => 'n';
                            '\r' => 'r';
                            '\t' => 't';
                            otherwise => #f;
                          end;
        if (escape-char)
          write-element(stream, '\\');
          write-element(stream, escape-char);
        else
          write-unicode-escape(code);
        end;
      char == '"' =>
        write(stream, "\\\"");
      char == '\\' =>
        write(stream, "\\\\");
      code < 127 =>             // omits DEL
        write-element(stream, char);
      otherwise =>
        write-unicode-escape(code);
    end case;
  end for;
  write-element(stream, '"');
end method;

define method encode-json (stream :: <stream>, object :: <integer>)
  write(stream, integer-to-string(object));
end;

define method encode-json (stream :: <stream>, object :: <float>)
  write(stream, float-to-string(object));
end;

define method encode-json (stream :: <stream>, object :: <symbol>)
  write(stream, "\"");
  write(stream, as(<string>, object));
  write(stream, "\"");
end;

define method encode-json (stream :: <stream>, object :: singleton(#f))
  write(stream, "false");
end;

define method encode-json (stream :: <stream>, object :: singleton(#t))
  write(stream, "true");
end;

define method encode-json (stream :: <stream>, object :: <collection>)
  write(stream, "[");
  for (o in object,
       i from 0)
    if (i > 0)
      write(stream, ", ");
    end if;
    encode-json(stream, o);
  end for;
  write(stream, "]");
end;

define method encode-json (stream :: <stream>, object :: <table>)
  write(stream, "{");
  for (value keyed-by key in object,
       i from 0)
    if (i > 0)
      write(stream, ", ");
    end if;
    encode-json(stream, key);
    write(stream, ":");
    encode-json(stream, value);
  end for;
  write(stream, "}");
end;
