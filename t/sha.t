use v6;
BEGIN { @*INC.unshift: './lib'; }

use Test;

plan 43;

use Sum::SHA;
ok 1,'We use Sum::SHA and we are still alive';

# fmt('%x') seems to have its limitations at present.
sub hexify ($i is copy) {
    join('',reverse (gather while $i { take ($i +& 0xffffffffffffffff).fmt('%x'); $i +>= 64; }));
}

class SHA1t does Sum::SHA1 does Sum::Marshal::Raw { };
my SHA1t $s .= new();
ok $s.WHAT === SHA1t, 'We create a SHA1 class and object';

is SHA1t.new().finalize(Buf.new()),
   0xda39a3ee5e6b4b0d3255bfef95601890afd80709,
   "SHA1 of an empty buffer is correct.";
is SHA1t.new().finalize(Buf.new(97)),
   0x86f7e437faa5a7fce15d1ddcb9eaeaea377667b8,
   "SHA1 of a 1-byte buffer is correct.";
is SHA1t.new().finalize(Buf.new(97 xx 55)),
   0xc1c8bbdc22796e28c0e15163d20899b65621d65a,
   "SHA1 of a 55-byte buffer is correct.";
is SHA1t.new().finalize(Buf.new(97 xx 56)),
   0xc2db330f6083854c99d4b5bfb6e8f29f201be699,
   "SHA1 of a 56-byte buffer is correct.";
is SHA1t.new().finalize(Buf.new(97 xx 64)),
   0x0098ba824b5c16427bd7a1122a5a442a25ec644d,
   "SHA1 of a 64-byte buffer is correct.";
is SHA1t.new().finalize(Buf.new(),True),
   0x59c4526aa2cc59f9a5f56b5579ba7108e7ccb61a,
   "SHA1 of a 1-bit buffer is correct.";
is SHA1t.new().finalize(Buf.new(),True,False,True,False,True,False,False),
   0x2a01d85e3f920e9161dfc9ff45fbb778b05ec263,
   "SHA1 of a 7-bit buffer is correct.";
is SHA1t.new().finalize(Buf.new(97),True),
   0x0a5f406d32e7c5fec1db35bddc1a9c148f459b04,
   "SHA1 of a 9-bit buffer is correct.";
is SHA1t.new().finalize(Buf.new(97 xx 55),True,False,True,False,True,False,False),
   0xc581ddabbdfbc68448a04f9d3d17eccd9d48906e,
   "SHA1 of a 447-bit buffer is correct.";
is SHA1t.new().finalize(Buf.new(97 xx 56),True),
   0xa728aa56bfeb09752ee39baeec23e1c5e3718de5, #TODO
   "SHA1 of a 449-bit buffer is correct.";
is SHA1t.new().finalize(Buf.new(97 xx 63),True,False,True,False,True,False,False),
   0xa1c70b7a97d935e841a9e6280a608fca953c0c91,
   "SHA1 of a 511-bit buffer is correct.";

class SHA0t does Sum::SHA1[:insecure_sha0_obselete] does Sum::Marshal::Raw { };
is SHA0t.new().finalize(Buf.new(97 xx 55)),
   0x0ff59f7cb9afc10d7abcdc9ab8c00e0e7b02034f,
   "obselete SHA0 tweak of SHA1 works.";

class SHA256t does Sum::SHA2[ :columns(256) ] does Sum::Marshal::Raw { };
my SHA256t $s2 .= new();
ok $s2.WHAT === SHA256t, 'We create a SHA2 (SHA-256) class and object';

is SHA256t.new().finalize(Buf.new()),
   0xe3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855,
   "SHA-256 of an empty buffer is correct.";
is SHA256t.new().finalize(Buf.new(97)),
   0xca978112ca1bbdcafac231b39a23dc4da786eff8147c4e72b9807785afee48bb,
   "SHA-256 of a 1-byte buffer is correct.";
is SHA256t.new().finalize(Buf.new(97 xx 55)),
   0x9f4390f8d30c2dd92ec9f095b65e2b9ae9b0a925a5258e241c9f1e910f734318,
   "SHA-256 of a 55-byte buffer is correct.";
is SHA256t.new().finalize(Buf.new(97 xx 56)),
   0xb35439a4ac6f0948b6d6f9e3c6af0f5f590ce20f1bde7090ef7970686ec6738a,
   "SHA-256 of a 56-byte buffer is correct.";
is SHA256t.new().finalize(Buf.new(97 xx 64)),
   0xffe054fe7ae0cb6dc65c3af9b61d5209f439851db43d0ba5997337df154668eb,
   "SHA-256 of a 64-byte buffer is correct.";

is SHA256t.new().finalize(Buf.new(),True),
   0xb9debf7d52f36e6468a54817c1fa071166c3a63d384850e1575b42f702dc5aa1,
   "SHA-256 of a 1-bit buffer is correct.";
is SHA256t.new().finalize(Buf.new(),True,False,True,False,True,False,False),
   0x0e5ba478e13af18fb66cfa7995471142101f9b32cc6f3f29c8a669c94eb6de77,
   "SHA-256 of a 7-bit buffer is correct.";
is SHA256t.new().finalize(Buf.new(97),True),
   0x32c537397864e2e698c4979136e342d4698902c84298398496608e46c3c92b83,
   "SHA-256 of a 9-bit buffer is correct.";
is SHA256t.new().finalize(Buf.new(97 xx 55),True,False,True,False,True,False,False),
   0x6982e8960c1d937d34586cdb06c1141dbe5fb7419ea24edd2941a1e0fd27a878,
   "SHA-256 of a 447-bit buffer is correct.";
is SHA256t.new().finalize(Buf.new(97 xx 56),True),
   0x5542226c1c374f9c41507bc327300284a42abd726d4ae6a25b357777903fb8bb,
   "SHA-256 of a 449-bit buffer is correct.";
is SHA256t.new().finalize(Buf.new(97 xx 63),True,False,True,False,True,False,False),
   0x5ffdf348fdad74aca3196af07b43730adfe366c394913e8ebc4f987d4d757a36,
   "SHA-256 of a 511-bit buffer is correct.";

class SHA224t does Sum::SHA2[ :columns(224) ] does Sum::Marshal::Raw { };
my SHA224t $s3 .= new();
ok $s3.WHAT === SHA224t, 'We create a SHA2 (SHA-224) class and object';
is SHA224t.new().finalize(Buf.new(97 xx 55)),
   0xfb0bd626a70c28541dfa781bb5cc4d7d7f56622a58f01a0b1ddd646f,
   "SHA-224 expected result is correct.";

class SHA512t does Sum::SHA2[ :columns(512) ] does Sum::Marshal::Raw { };
my SHA512t $s4 .= new();
ok $s4.WHAT === SHA512t, 'We create a SHA2 (SHA-512) class and object';

is SHA512t.new().finalize(Buf.new()),
   0xcf83e1357eefb8bdf1542850d66d8007d620e4050b5715dc83f4a921d36ce9ce47d0d13c5d85f2b0ff8318d2877eec2f63b931bd47417a81a538327af927da3e,
   "SHA-512 of an empty buffer is correct.";
is SHA512t.new().finalize(Buf.new(97)),
   0x1f40fc92da241694750979ee6cf582f2d5d7d28e18335de05abc54d0560e0f5302860c652bf08d560252aa5e74210546f369fbbbce8c12cfc7957b2652fe9a75,
   "SHA-512 of a 1-byte buffer is correct.";
is SHA512t.new().finalize(Buf.new(97 xx 111)),
   0xfa9121c7b32b9e01733d034cfc78cbf67f926c7ed83e82200ef86818196921760b4beff48404df811b953828274461673c68d04e297b0eb7b2b4d60fc6b566a2,
   "SHA-512 of a 111-byte buffer is correct.";
is SHA512t.new().finalize(Buf.new(97 xx 112)),
   0xc01d080efd492776a1c43bd23dd99d0a2e626d481e16782e75d54c2503b5dc32bd05f0f1ba33e568b88fd2d970929b719ecbb152f58f130a407c8830604b70ca,
   "SHA-512 of a 112-byte buffer is correct.";
is SHA512t.new().finalize(Buf.new(97 xx 128)),
   0xb73d1929aa615934e61a871596b3f3b33359f42b8175602e89f7e06e5f658a243667807ed300314b95cacdd579f3e33abdfbe351909519a846d465c59582f321,
   "SHA-512 of a 128-byte buffer is correct.";

is SHA512t.new().finalize(Buf.new(),True),
   0x5f72ee8494a425ba13fc8c48ac0a05cbaae7e932e471e948cb524333745aa432c1851c0c43682b0e67d64626f8f45cf165f6b538a94c63be98224e969e75d7ed,
   "SHA-512 of a 1-bit buffer is correct.";
is SHA512t.new().finalize(Buf.new(),True,False,True,False,True,False,False),
   0x94c664b71997309af62e6196f574850db1582e7a46c13fd3af091a20c343924df9d633a1a104e5397c4e9032b853d1ed6ee9db95573ce57c460930f370a174cd,
   "SHA-512 of a 7-bit buffer is correct.";
is SHA512t.new().finalize(Buf.new(97),True),
   0x556467a856fa48f7f6087b59e5ff23c0d96a9fa5175c3c07699c69784afd2bae33a6873b97d8aa127aebf5febc0b40d34a4475cdb828ad91fc24d9be738285dd,
   "SHA-512 of a 9-bit buffer is correct.";
is SHA512t.new().finalize(Buf.new(97 xx 111),True,False,True,False,True,False,False),
   0x9047c7f662d106c57245a810aa5f8abc04e7236e6f75295e1f170b5b94d52a40f457fda58443cf997c160b1a29753d77e0ba6fd19caaa03d3634b9c18fd81af0,
   "SHA-512 of a 895-bit buffer is correct.";
is SHA512t.new().finalize(Buf.new(97 xx 112),True),
   0x77a3173ec2b388acdf8a72a8952126df13fb664f662f8ece563fd1ddd8b86ea23eb01f7a17beb82239d9ed1905a9b52dffbba725ec4bd35afec9bdb14dbdd079,
   "SHA-512 of a 897-bit buffer is correct.";
is SHA512t.new().finalize(Buf.new(97 xx 127),True,False,True,False,True,False,False),
   0x33d2f8ddd4822267842fcf6cf600c3d8dbefe31fab82c6e9b2940a2d943c4938094e6c08bc9dc1886afde69c5d087d1a5d23f98c122bd55b2be97ed789040fbf,
   "SHA-512 of a 1023-bit buffer is correct.";

class SHA384t does Sum::SHA2[ :columns(384) ] does Sum::Marshal::Raw { };
my SHA384t $s5 .= new();
ok $s5.WHAT === SHA384t, 'We create a SHA2 (SHA-384) class and object';

is SHA384t.new().finalize(Buf.new(97 xx 111)),
   0x3c37955051cb5c3026f94d551d5b5e2ac38d572ae4e07172085fed81f8466b8f90dc23a8ffcdea0b8d8e58e8fdacc80a,
   "SHA-384 expected result is correct.";

# Now grab the code in the synopsis from the POD and make sure it runs.
# This is currently complete hackery but might improve when pod support does.
# And also an outputs_ok Test.pm function that redirects $*OUT might be nice.
class sayer {
    has $.accum is rw = "";
    method print (*@s) { $.accum ~= [~] @s }
}
my sayer $p .= new();
{ temp $*OUT = $p; eval $Sum::SHA::Doc::synopsis; }
is $p.accum, $Sum::SHA::Doc::synopsis.comb(/<.after \#\s> (<.ws> <.xdigit>+)+/).join("\n") ~ "\n", 'Code in manpage synopsis actually works';