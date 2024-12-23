# generated by clj2nix-1.1.0-rc
{
  fetchMavenArtifact,
  fetchgit,
  lib,
}:

let
  repos = [
    "https://repo1.maven.org/maven2/"
    "https://repo.clojars.org/"
  ];

in
rec {
  makePaths =
    {
      extraClasspaths ? [ ],
    }:
    if (builtins.typeOf extraClasspaths != "list") then
      builtins.throw "extraClasspaths must be of type 'list'!"
    else
      (lib.concatMap (
        dep:
        builtins.map (
          path:
          if builtins.isString path then
            path
          else if builtins.hasAttr "jar" path then
            path.jar
          else if builtins.hasAttr "outPath" path then
            path.outPath
          else
            path
        ) dep.paths
      ) packages)
      ++ extraClasspaths;
  makeClasspaths =
    {
      extraClasspaths ? [ ],
    }:
    if (builtins.typeOf extraClasspaths != "list") then
      builtins.throw "extraClasspaths must be of type 'list'!"
    else
      builtins.concatStringsSep ":" (makePaths {
        inherit extraClasspaths;
      });
  packageSources = builtins.map (dep: dep.src) packages;
  packages = [
    rec {
      name = "transit-java/com.cognitect";
      src = fetchMavenArtifact {
        inherit repos;
        artifactId = "transit-java";
        groupId = "com.cognitect";
        sha512 = "294725b1003323981d1ffa0a6952fbe152e7704b2cbef91c848958df56d0b4d8642eae717398d9859d8e04d77ccebc64e238db2b12d637b6fef43c25a2191999";
        version = "1.0.362";

      };
      paths = [ src ];
    }

    rec {
      name = "data.json/org.clojure";
      src = fetchMavenArtifact {
        inherit repos;
        artifactId = "data.json";
        groupId = "org.clojure";
        sha512 = "04b7c0c90cb26d643a0b3e7e1ffa2d2d423e977c1454ee5ea7c2e75547ecbc113838df17b797902a975f5ea2184a81a45b605a4d82970805e2bbb02feebc578d";
        version = "2.4.0";

      };
      paths = [ src ];
    }

    rec {
      name = "clojure/org.clojure";
      src = fetchMavenArtifact {
        inherit repos;
        artifactId = "clojure";
        groupId = "org.clojure";
        sha512 = "1925300a0fe4cc9fc3985910bb04ae65a19ce274dacc5ec76e708cfa87a7952a0a77282b083d0aebb2206afff619af73a57f0d661a3423601586f0829cc7956b";
        version = "1.11.1";

      };
      paths = [ src ];
    }

    rec {
      name = "shadow-cljsjs/thheller";
      src = fetchMavenArtifact {
        inherit repos;
        artifactId = "shadow-cljsjs";
        groupId = "thheller";
        sha512 = "3d0b79eff075c38389d9f3501c60bf91a28a6ee25fc0a2df3159b365eff556e2ec8499b69860783478705ea33ff18e85fc0150229d5725e58e96f362bdc777f1";
        version = "0.0.22";

      };
      paths = [ src ];
    }

    rec {
      name = "commons-codec/commons-codec";
      src = fetchMavenArtifact {
        inherit repos;
        artifactId = "commons-codec";
        groupId = "commons-codec";
        sha512 = "da30a716770795fce390e4dd340a8b728f220c6572383ffef55bd5839655d5611fcc06128b2144f6cdcb36f53072a12ec80b04afee787665e7ad0b6e888a6787";
        version = "1.15";

      };
      paths = [ src ];
    }

    rec {
      name = "tools.analyzer/org.clojure";
      src = fetchMavenArtifact {
        inherit repos;
        artifactId = "tools.analyzer";
        groupId = "org.clojure";
        sha512 = "c51752a714848247b05c6f98b54276b4fe8fd44b3d970070b0f30cd755ac6656030fd8943a1ffd08279af8eeff160365be47791e48f05ac9cc2488b6e2dfe504";
        version = "1.1.0";

      };
      paths = [ src ];
    }

    rec {
      name = "cljs-test-display/com.bhauman";
      src = fetchMavenArtifact {
        inherit repos;
        artifactId = "cljs-test-display";
        groupId = "com.bhauman";
        sha512 = "d8aafc0214bb3719adbb2c957e6a7c939e0db65a0bf69c4369654f736882c3203a4eeb66670e1da18f60faa8bf97b094712472ce883a5a1a5f8dd52b8e413d96";
        version = "0.1.1";

      };
      paths = [ src ];
    }

    rec {
      name = "core.specs.alpha/org.clojure";
      src = fetchMavenArtifact {
        inherit repos;
        artifactId = "core.specs.alpha";
        groupId = "org.clojure";
        sha512 = "f521f95b362a47bb35f7c85528c34537f905fb3dd24f2284201e445635a0df701b35d8419d53c6507cc78d3717c1f83cda35ea4c82abd8943cd2ab3de3fcad70";
        version = "0.2.62";

      };
      paths = [ src ];
    }

    rec {
      name = "cljs-http/cljs-http";
      src = fetchMavenArtifact {
        inherit repos;
        artifactId = "cljs-http";
        groupId = "cljs-http";
        sha512 = "dd2938d8df8aa6a5597459d11097152de3f5e0f38508aef8328b8de173355f81b0ac2eef215955090de4a9c50b21c0ae6b51e85791d4358aa3ec659be58437df";
        version = "0.1.46";

      };
      paths = [ src ];
    }

    rec {
      name = "undertow-core/io.undertow";
      src = fetchMavenArtifact {
        inherit repos;
        artifactId = "undertow-core";
        groupId = "io.undertow";
        sha512 = "d1dcc1236ac98518318bea1ab99037c4f447d431319dc9fa8a9bc830c2c3cee0f7b804cfb5492e71e68e96a128f259059de8d6404237572c78643c8824818b9b";
        version = "2.2.4.Final";

      };
      paths = [ src ];
    }

    rec {
      name = "expound/expound";
      src = fetchMavenArtifact {
        inherit repos;
        artifactId = "expound";
        groupId = "expound";
        sha512 = "01c3c05c115ed06c558bf0e1ff088e414b1b49450cb67e1b7d08faf2e08c1d133e511e73c7a008b1d839dd7625541594eb29b45e97c0f9544d518d9c1e88e1ea";
        version = "0.8.6";

      };
      paths = [ src ];
    }

    rec {
      name = "spec.alpha/org.clojure";
      src = fetchMavenArtifact {
        inherit repos;
        artifactId = "spec.alpha";
        groupId = "org.clojure";
        sha512 = "ddfe4fa84622abd8ac56e2aa565a56e6bdc0bf330f377ff3e269ddc241bb9dbcac332c13502dfd4c09c2c08fe24d8d2e8cf3d04a1bc819ca5657b4e41feaa7c2";
        version = "0.3.218";

      };
      paths = [ src ];
    }

    rec {
      name = "tools.cli/org.clojure";
      src = fetchMavenArtifact {
        inherit repos;
        artifactId = "tools.cli";
        groupId = "org.clojure";
        sha512 = "1d88aa03eb6a664bf2c0ce22c45e7296d54d716e29b11904115be80ea1661623cf3e81fc222d164047058239010eb678af92ffedc7c3006475cceb59f3b21265";
        version = "1.0.206";

      };
      paths = [ src ];
    }

    rec {
      name = "commons-fileupload/commons-fileupload";
      src = fetchMavenArtifact {
        inherit repos;
        artifactId = "commons-fileupload";
        groupId = "commons-fileupload";
        sha512 = "a8780b7dd7ab68f9e1df38e77a5207c45ff50ec53d8b1476570d069edc8f59e52fb1d0fc534d7e513ac5a01b385ba73c320794c82369a72bd6d817a3b3b21f39";
        version = "1.4";

      };
      paths = [ src ];
    }

    rec {
      name = "glogi/com.lambdaisland";
      src = fetchMavenArtifact {
        inherit repos;
        artifactId = "glogi";
        groupId = "com.lambdaisland";
        sha512 = "3894e3323af1a1fb8273834460712c02b59d9439cabe77863971d04de59a2aabb46402694c3ac75109f30a92d057cd01d225c0ba27a91fc8c4796b3299442127";
        version = "1.1.144";

      };
      paths = [ src ];
    }

    rec {
      name = "cljs-priority-map/tailrecursion";
      src = fetchMavenArtifact {
        inherit repos;
        artifactId = "cljs-priority-map";
        groupId = "tailrecursion";
        sha512 = "788cbc93520c9a5155bb5c949fb49016caea292b4be4f1f349ace2269273727a637c5d023c8276381b6afba60ab70dd82d21f4caa03371b6659474f16a66cba9";
        version = "1.2.1";

      };
      paths = [ src ];
    }

    rec {
      name = "clojure-future-spec/clojure-future-spec";
      src = fetchMavenArtifact {
        inherit repos;
        artifactId = "clojure-future-spec";
        groupId = "clojure-future-spec";
        sha512 = "7e71227dd4f2a5e9c6966fa6279ed66844721ffda2c66e8cdab2bc79a976c7070763baa2104a4337433fd8d991b7aa2e8ddf981974be664dce93410c47a68bb4";
        version = "1.9.0";

      };
      paths = [ src ];
    }

    rec {
      name = "tools.analyzer.jvm/org.clojure";
      src = fetchMavenArtifact {
        inherit repos;
        artifactId = "tools.analyzer.jvm";
        groupId = "org.clojure";
        sha512 = "36ad50a7a79c47dea16032fc4b927bd7b56b8bedcbd20cc9c1b9c85edede3a455369b8806509b56a48457dcd32e1f708f74228bce2b4492bd6ff6fc4f1219d56";
        version = "1.2.2";

      };
      paths = [ src ];
    }

    rec {
      name = "wildfly-common/org.wildfly.common";
      src = fetchMavenArtifact {
        inherit repos;
        artifactId = "wildfly-common";
        groupId = "org.wildfly.common";
        sha512 = "f99f23af23a1cc45035b87ab422affdb911769ee63dc5a1c9b3e7a39ebefee07542d2388118282b20113c196e28abce8f87cafc8b0213cdc692381edce035c46";
        version = "1.5.2.Final";

      };
      paths = [ src ];
    }

    rec {
      name = "react-dom/cljsjs";
      src = fetchMavenArtifact {
        inherit repos;
        artifactId = "react-dom";
        groupId = "cljsjs";
        sha512 = "825ee3b83a21f2ded10bb1e89d2f45bd6f9ed1beeda40080112c2275bb84d32526f39b4795db26ebb2665c07095bf8da1df25a697661587272e0b7ef10f7da10";
        version = "16.8.6-0";

      };
      paths = [ src ];
    }

    rec {
      name = "noencore/noencore";
      src = fetchMavenArtifact {
        inherit repos;
        artifactId = "noencore";
        groupId = "noencore";
        sha512 = "111d8ab0c59a43b09cd4337b9dac2978b5210519c347c0c28ef52bd554e50d4182e6fa20d9389f3881ed0a8aa845150f10abc1891cba541a2daf43e842c86273";
        version = "0.3.4";

      };
      paths = [ src ];
    }

    rec {
      name = "json-simple/com.googlecode.json-simple";
      src = fetchMavenArtifact {
        inherit repos;
        artifactId = "json-simple";
        groupId = "com.googlecode.json-simple";
        sha512 = "f8798bfbcc8ab8001baf90ce47ec2264234dc1da2d4aa97fdcdc0990472a6b5a5a32f828e776140777d598a99d8a0c0f51c6d0767ae1a829690ab9200ae35742";
        version = "1.1.1";

      };
      paths = [ src ];
    }

    rec {
      name = "transit-cljs/com.cognitect";
      src = fetchMavenArtifact {
        inherit repos;
        artifactId = "transit-cljs";
        groupId = "com.cognitect";
        sha512 = "526d3331857586ab7e8edb78795c375aaafe6dc3da24706663918a7dc38e25db7d0f554c334ec3be0334050d59d8616bd9cd6c9a90cf4bb4b33b1e0ea294d29c";
        version = "0.8.269";

      };
      paths = [ src ];
    }

    rec {
      name = "google-closure-library/org.clojure";
      src = fetchMavenArtifact {
        inherit repos;
        artifactId = "google-closure-library";
        groupId = "org.clojure";
        sha512 = "85e259bd189554659fdcb2f137c7de81a8aac97669b865254c59c713e6a8b79eb4272fa1444b9bfc5d1c8447140daa53aac74cacd21527e6186cf1ec0e776d32";
        version = "0.0-20211011-0726fdeb";

      };
      paths = [ src ];
    }

    rec {
      name = "shadow-cljs/thheller";
      src = fetchMavenArtifact {
        inherit repos;
        artifactId = "shadow-cljs";
        groupId = "thheller";
        sha512 = "090a6b3dbb4973ebcaf17cc32b8d5d32f6bf5c5ed3cbd556c7cff97241831f077d7b727a30ee424367bb6eb22322c5599559a1437f4145042650344566ffb2d5";
        version = "2.19.0";

      };
      paths = [ src ];
    }

    rec {
      name = "rewrite-clj/rewrite-clj";
      src = fetchMavenArtifact {
        inherit repos;
        artifactId = "rewrite-clj";
        groupId = "rewrite-clj";
        sha512 = "908452081a4d44c964c5cc8d870de7d23c41a828b638d8f4e85850b83e0ad52fd21b3deda3ea9ff95e03dcbe810c9744fdcde99e6783ae9704e84ee4548779e5";
        version = "1.1.47";

      };
      paths = [ src ];
    }

    rec {
      name = "clojurescript/org.clojure";
      src = fetchMavenArtifact {
        inherit repos;
        artifactId = "clojurescript";
        groupId = "org.clojure";
        sha512 = "52a87daca0e149f6feaf2e1459f34cf9ce034ef94cbcf0eaa65cd6ad779fdefe73e1a9e339b295e968ae9b85561b6c4cd2354173b835a54843de5d7c2eff7922";
        version = "1.11.54";

      };
      paths = [ src ];
    }

    rec {
      name = "cljs-bean/cljs-bean";
      src = fetchMavenArtifact {
        inherit repos;
        artifactId = "cljs-bean";
        groupId = "cljs-bean";
        sha512 = "044bc011a7a63929b5b12e0d8bcea1aa7f69722359e90955a91590be62441a991aa3ba4117607028dbadf02e9e7da94079609ae50e91b699f301b7461f752ffc";
        version = "1.5.0";

      };
      paths = [ src ];
    }

    rec {
      name = "commons-io/commons-io";
      src = fetchMavenArtifact {
        inherit repos;
        artifactId = "commons-io";
        groupId = "commons-io";
        sha512 = "6af22dffaaecd1553147e788b5cf50368582318f396e456fe9ff33f5175836713a5d700e51720465c932c2b1987daa83027358005812d6a95d5755432de3a79d";
        version = "2.10.0";

      };
      paths = [ src ];
    }

    rec {
      name = "tools.namespace/org.clojure";
      src = fetchMavenArtifact {
        inherit repos;
        artifactId = "tools.namespace";
        groupId = "org.clojure";
        sha512 = "b599070c4696059128488ba0e12f5b1deb40ec27a985fb489a3c33e91e264ce8e96740c361c60abef5db465bf5036bfee1c3cd3d3ff87999925cfc9190340278";
        version = "0.2.11";

      };
      paths = [ src ];
    }

    rec {
      name = "fipp/fipp";
      src = fetchMavenArtifact {
        inherit repos;
        artifactId = "fipp";
        groupId = "fipp";
        sha512 = "0c3bf011d9eec32993ccdf66910f818b4b0d80513c2cfb1cf6fc9714ec3d01ec4485397c90a6a0a4c0e30261323eabf0c090251c49c05061ab701292c5ad4306";
        version = "0.6.26";

      };
      paths = [ src ];
    }

    rec {
      name = "jboss-logging/org.jboss.logging";
      src = fetchMavenArtifact {
        inherit repos;
        artifactId = "jboss-logging";
        groupId = "org.jboss.logging";
        sha512 = "c17b8882481c0cb8fbcdf7ea33d268e2173b1bfe04be71e61d5f07c3040b1c33b58781063f8ebf27325979d02255e62d1df16a633ac22f9d08adeb5c6b83a32a";
        version = "3.4.1.Final";

      };
      paths = [ src ];
    }

    rec {
      name = "jackson-core/com.fasterxml.jackson.core";
      src = fetchMavenArtifact {
        inherit repos;
        artifactId = "jackson-core";
        groupId = "com.fasterxml.jackson.core";
        sha512 = "a1bd6c264b9ab07aad3d0f26b65757e35ff47904ab895bb7f997e3e1fd063129c177ad6f69876907b04ff8a43c6b1770a26f53a811633a29e66a5dce57194f64";
        version = "2.8.7";

      };
      paths = [ src ];
    }

    rec {
      name = "asm/org.ow2.asm";
      src = fetchMavenArtifact {
        inherit repos;
        artifactId = "asm";
        groupId = "org.ow2.asm";
        sha512 = "876eac7406e60ab8b9bd6cd3c221960eaa53febea176a88ae02f4fa92dbcfe80a3c764ba390d96b909c87269a30a69b1ee037a4c642c2f535df4ea2e0dd499f2";
        version = "9.2";

      };
      paths = [ src ];
    }

    rec {
      name = "react/cljsjs";
      src = fetchMavenArtifact {
        inherit repos;
        artifactId = "react";
        groupId = "cljsjs";
        sha512 = "79034721f5c44fc90887f6d31adc89794132c7e21a75439cb98bb2522e87fe906041c4b92aaf9dc349dcbe9352d0f22f8d9ec78817517eebce7de99ef760265c";
        version = "16.8.6-0";

      };
      paths = [ src ];
    }

    rec {
      name = "shadow-util/thheller";
      src = fetchMavenArtifact {
        inherit repos;
        artifactId = "shadow-util";
        groupId = "thheller";
        sha512 = "803a068159276f5abf6d9cfa25f5c446c4c66d2eaec78393910cb2175b63a734c7c7effaf3064789608b1cf3899c287611c2d170fd78621193acc1fbbff1d5da";
        version = "0.7.0";

      };
      paths = [ src ];
    }

    rec {
      name = "arrangement/mvxcvi";
      src = fetchMavenArtifact {
        inherit repos;
        artifactId = "arrangement";
        groupId = "mvxcvi";
        sha512 = "0898874aaebe760c9ef30f7a5bd3d92afc98d845aa8859dd5cde4a3096ef688132d8d8c6161c5ce0b3ccafae3b792173c6ade4b5c901eec8d81107f2c812ff68";
        version = "2.0.0";

      };
      paths = [ src ];
    }

    rec {
      name = "instaparse/instaparse";
      src = fetchMavenArtifact {
        inherit repos;
        artifactId = "instaparse";
        groupId = "instaparse";
        sha512 = "fe66379c8ca5692d8ab683d67e78754a2093127970ac0077ded743a669314b8ce8224cfd44e596e011a31f6f3cb6778895d1846afe162b77052d1218ee25bbfc";
        version = "1.4.10";

      };
      paths = [ src ];
    }

    rec {
      name = "transit-js/com.cognitect";
      src = fetchMavenArtifact {
        inherit repos;
        artifactId = "transit-js";
        groupId = "com.cognitect";
        sha512 = "bab8c657449a1d01e884923b77c5ef3d7a1a246c3ad1bd85a5b0c98b7952dbdeea97ce7d340ab50aa0dca647a1ef7eb846a52a1a4eecc55e1ff22145b8e820fe";
        version = "0.8.874";

      };
      paths = [ src ];
    }

    rec {
      name = "directory-watcher/io.methvin";
      src = fetchMavenArtifact {
        inherit repos;
        artifactId = "directory-watcher";
        groupId = "io.methvin";
        sha512 = "bcd346c08d73980e05592690e3525889c241f878909c85d7e097c7f99f38c64693870b69a41bfc0b02a4749387cef45089554898cfec4df5fda43a48acb3a7d1";
        version = "0.15.1";

      };
      paths = [ src ];
    }

    rec {
      name = "reitit-core/metosin";
      src = fetchMavenArtifact {
        inherit repos;
        artifactId = "reitit-core";
        groupId = "metosin";
        sha512 = "22c57f0bb0f5c398c9156b155d78575f05980ee09fa8a5744cafc24ba149f25bbf10c5ab1aa0ca3b9a3dd83c3d23f126b3257fc5395964128d73c7915b1fa549";
        version = "0.3.10";

      };
      paths = [ src ];
    }

    rec {
      name = "datascript-transit/datascript-transit";
      src = fetchMavenArtifact {
        inherit repos;
        artifactId = "datascript-transit";
        groupId = "datascript-transit";
        sha512 = "dc307224c2a5c30776f0658ec8ec679d79d4daa4f9cee6b9f39c7f77ec5c39e2104e8da2a2eeee67a23aa5395b51357967dd0d825016cb7227f736b484377783";
        version = "0.3.0";

      };
      paths = [ src ];
    }

    rec {
      name = "google-closure-library-third-party/org.clojure";
      src = fetchMavenArtifact {
        inherit repos;
        artifactId = "google-closure-library-third-party";
        groupId = "org.clojure";
        sha512 = "2ceef3cbba119d66a38619dc4309ee9eb5e3cccacae0a50e7f099a8df160e345e1abeaa315285fe0328c6afc842a77f6fa9d3c710745b07ce8d484caca7f47bf";
        version = "0.0-20211011-0726fdeb";

      };
      paths = [ src ];
    }

    rec {
      name = "cljs-cache/org.clojars.mmb90";
      src = fetchMavenArtifact {
        inherit repos;
        artifactId = "cljs-cache";
        groupId = "org.clojars.mmb90";
        sha512 = "4ec04b9d4eece3854ef1efb0d51981b132ac4e4068c1fc167b2a8e688500577cfccfc5dfbbdb8b3f8a45e72e814c4b8c2f0df89e6cc21d5f1be34f13ede63173";
        version = "0.1.4";

      };
      paths = [ src ];
    }

    rec {
      name = "rum/rum";
      src = fetchMavenArtifact {
        inherit repos;
        artifactId = "rum";
        groupId = "rum";
        sha512 = "d10db9a605a92b720f284000b9e6a457f31362dae25f49adfd16bb7f613e6d234062a63fd956bca0d5f7f9329a0298533a9b321af05abb76ca1b836f5e51a01d";
        version = "0.12.9";

      };
      paths = [ src ];
    }

    rec {
      name = "hiccup/hiccup";
      src = fetchMavenArtifact {
        inherit repos;
        artifactId = "hiccup";
        groupId = "hiccup";
        sha512 = "034f15be46c35029f41869c912f82cb2929fbbb0524ea64bd98dcdb9cf09875b28c75e926fa5fff53942b0f9e543e85a73a2d03c3f2112eecae30fcef8b148f4";
        version = "1.0.5";

      };
      paths = [ src ];
    }

    rec {
      name = "javassist/org.javassist";
      src = fetchMavenArtifact {
        inherit repos;
        artifactId = "javassist";
        groupId = "org.javassist";
        sha512 = "ad65ee383ed83bedecc2073118cb3780b68b18d5fb79a1b2b665ff8529df02446ad11e68f9faaf4f2e980065f5946761a59ada379312cbb22d002625abed6a4f";
        version = "3.18.1-GA";

      };
      paths = [ src ];
    }

    rec {
      name = "xnio-nio/org.jboss.xnio";
      src = fetchMavenArtifact {
        inherit repos;
        artifactId = "xnio-nio";
        groupId = "org.jboss.xnio";
        sha512 = "7f2c53222caf40793b1c956aa08ff3316a86577e6a79274050bcdf700b68546397b286e3d693c1b3036fe9175f54f76816cbf6a100ae67f9e6c20b4ca028e56d";
        version = "3.8.0.Final";

      };
      paths = [ src ];
    }

    rec {
      name = "dynaload/borkdude";
      src = fetchMavenArtifact {
        inherit repos;
        artifactId = "dynaload";
        groupId = "borkdude";
        sha512 = "d2ac2b6ef2983c824b7df048c0d4822c06fd2faa92044a9c617280beb06c091bfeeaadc6d50275165211a07b376be995974c58ac3ee2846095b838fb5b31c92e";
        version = "0.3.5";

      };
      paths = [ src ];
    }

    rec {
      name = "boot-test/adzerk";
      src = fetchMavenArtifact {
        inherit repos;
        artifactId = "boot-test";
        groupId = "adzerk";
        sha512 = "5230f84f6c18ec4703607fa5d8e488c0cbb484681f7092d85bdbb835058df0baad654d33cd4eaabf1b6f53b213772f739ac850f2fd4cf110d3485e0a5aa8f7be";
        version = "1.1.2";

      };
      paths = [ src ];
    }

    rec {
      name = "devtools/binaryage";
      src = fetchMavenArtifact {
        inherit repos;
        artifactId = "devtools";
        groupId = "binaryage";
        sha512 = "35bd936ad52e738a8f74decec544fd1cddb2881efb94232e7d4d28cb48ac91bb015a1a1e15ef8ba2df5ee40fac9901bd2588ebe537519b3f8c05f9b2051bd2d4";
        version = "1.0.5";

      };
      paths = [ src ];
    }

    rec {
      name = "msgpack/org.msgpack";
      src = fetchMavenArtifact {
        inherit repos;
        artifactId = "msgpack";
        groupId = "org.msgpack";
        sha512 = "a2741bed01f9c37ba3dbe6a7ab9ce936d36d4da97c35e215250ac89ac0851fc5948d83975ea6257d5dce1d43b6b5147254ecfb4b33f9bbdc489500b3ff060449";
        version = "0.6.12";

      };
      paths = [ src ];
    }

    rec {
      name = "edamame/borkdude";
      src = fetchMavenArtifact {
        inherit repos;
        artifactId = "edamame";
        groupId = "borkdude";
        sha512 = "578024a18e508c602ea7278195d8d3b7aee210a116ecfa8b5bf404f31ea666f0a137a99bb3b4be42c363ebf30507d499eb27b9dd695835ea38942eb5d5fbfa1b";
        version = "1.0.0";

      };
      paths = [ src ];
    }

    rec {
      name = "jboss-threads/org.jboss.threads";
      src = fetchMavenArtifact {
        inherit repos;
        artifactId = "jboss-threads";
        groupId = "org.jboss.threads";
        sha512 = "12d2b4c6c4f732a4b9437ae6e893087981aa2d829c9bad7089cd4cb10bccd7105e136f694e43a36e5bf234ca81294117fd9f6a07795f77c0f80d8f748c8fa529";
        version = "3.1.0.Final";

      };
      paths = [ src ];
    }

    rec {
      name = "malli/metosin";
      src = fetchMavenArtifact {
        inherit repos;
        artifactId = "malli";
        groupId = "metosin";
        sha512 = "614534815b545a4db4727f02eb180306e8aacc4b17c42b9d02090592f068f0b21c60d772aa146882595c47d5374981219e9ff14bf770c98b9f8de531118c0f1c";
        version = "0.10.0";

      };
      paths = [ src ];
    }

    rec {
      name = "transit-clj/com.cognitect";
      src = fetchMavenArtifact {
        inherit repos;
        artifactId = "transit-clj";
        groupId = "com.cognitect";
        sha512 = "f04e0e4f76bcc684559e479cdc1cc39822eab869cc07f972040fb9778b0bcffe73a9518e9b58134f0b9c0ba4e5a115c065756b4423b4816db36eb382a9972c48";
        version = "1.0.329";

      };
      paths = [ src ];
    }

    rec {
      name = "quoin/quoin";
      src = fetchMavenArtifact {
        inherit repos;
        artifactId = "quoin";
        groupId = "quoin";
        sha512 = "792e2861abd79747fde6cbd107424b2b471449cb555106070e2d073787e79ddbda66504b0a79caa713f21051d0826e6edb9deea68d811d983ab95289b150d612";
        version = "0.1.2";

      };
      paths = [ src ];
    }

    rec {
      name = "crypto-random/crypto-random";
      src = fetchMavenArtifact {
        inherit repos;
        artifactId = "crypto-random";
        groupId = "crypto-random";
        sha512 = "3520df744f250dbe061d1a5d7a05b7143f3a67a4c3f9ad87b8044ee68a36a702a0bcb3a203e35d380899dd01c28e01988b0a7af914b942ccbe0c35c9bdb22e11";
        version = "1.2.1";

      };
      paths = [ src ];
    }

    rec {
      name = "ring-codec/ring";
      src = fetchMavenArtifact {
        inherit repos;
        artifactId = "ring-codec";
        groupId = "ring";
        sha512 = "38b9775a794831b8afd8d66991a75aa5910cd50952c9035866bf9cc01353810aedafbc3f35d8f9e56981ebf9e5c37c00b968759ed087d2855348b3f46d8d0487";
        version = "1.1.3";

      };
      paths = [ src ];
    }

    rec {
      name = "shadow-client/thheller";
      src = fetchMavenArtifact {
        inherit repos;
        artifactId = "shadow-client";
        groupId = "thheller";
        sha512 = "b1f2ac82b31841d265af0939ecc0824e6ba8cc28d15b44c77f3abb305b5e88465b839915a222016c2ac8c7e2049d1daa2a3eebb9a58cdc9cf653bc56712b4ca7";
        version = "1.3.3";

      };
      paths = [ src ];
    }

    rec {
      name = "core.rrb-vector/org.clojure";
      src = fetchMavenArtifact {
        inherit repos;
        artifactId = "core.rrb-vector";
        groupId = "org.clojure";
        sha512 = "8204b559d2704105741e1c9a5b8c639161a4f4af09e18b93d6af23685dd8bdebd66b64e626a4daa69069759c423640b3a3787216b78c2e62c891650e2269e8a0";
        version = "0.1.2";

      };
      paths = [ src ];
    }

    rec {
      name = "cljs-drag-n-drop/cljs-drag-n-drop";
      src = fetchMavenArtifact {
        inherit repos;
        artifactId = "cljs-drag-n-drop";
        groupId = "cljs-drag-n-drop";
        sha512 = "05521a2f94d18409f57cdcd3da71ea97304ef112c148a1c012d1fed78978f3871d6c5c3bc8a1ba2b57a8b999ad863b34b6031b595c1e4d0893a326d18d392742";
        version = "0.1.0";

      };
      paths = [ src ];
    }

    rec {
      name = "crypto-equality/crypto-equality";
      src = fetchMavenArtifact {
        inherit repos;
        artifactId = "crypto-equality";
        groupId = "crypto-equality";
        sha512 = "54cf3bd28f633665962bf6b41f5ccbf2634d0db210a739e10a7b12f635e13c7ef532efe1d5d8c0120bb46478bbd08000b179f4c2dd52123242dab79fea97d6a6";
        version = "1.0.0";

      };
      paths = [ src ];
    }

    rec {
      name = "promesa/funcool";
      src = fetchMavenArtifact {
        inherit repos;
        artifactId = "promesa";
        groupId = "funcool";
        sha512 = "488d4503a0c8dca1071659172bb18f98d374cfbbe6a0d63934462f355338285d9b6c7136d1b84b239a2ca878c120625cf3b59e0cf00c44cc722bcd4d24f12e2e";
        version = "4.0.2";

      };
      paths = [ src ];
    }

    rec {
      name = "wildfly-client-config/org.wildfly.client";
      src = fetchMavenArtifact {
        inherit repos;
        artifactId = "wildfly-client-config";
        groupId = "org.wildfly.client";
        sha512 = "3f442478c57f7dfac7039f6c7ae014bb2d45cdbd690ee631a3349edbca414adfe1984d065d1439f9b1546fa15fbd032c3a6bfe008f1ad50eef74201467b9f55f";
        version = "1.0.1.Final";

      };
      paths = [ src ];
    }

    rec {
      name = "persistent-sorted-set/persistent-sorted-set";
      src = fetchMavenArtifact {
        inherit repos;
        artifactId = "persistent-sorted-set";
        groupId = "persistent-sorted-set";
        sha512 = "a1f4ef6ce34f5f515e04a5123ec98cedcbdcc9d6b58c9224850c604e70f6258c49aa03a70f501d4b02b24e4200e786054211bfb38c27c93d6630b8fdd92865c1";
        version = "0.3.0";

      };
      paths = [ src ];
    }

    rec {
      name = "jna/net.java.dev.jna";
      src = fetchMavenArtifact {
        inherit repos;
        artifactId = "jna";
        groupId = "net.java.dev.jna";
        sha512 = "ee8d8aa63c67561880626a2f84412fb6996b411e065060cbe4669cc2b4e5537d09acd6d262e1924f0c066d76b18a2bd8a94e96f313b3ffd12f4735b8f6e06bb5";
        version = "5.7.0";

      };
      paths = [ src ];
    }

    (rec {
      name = "com.andrewmcveigh/cljs-time";
      src = fetchgit {
        name = "cljs-time";
        url = "https://github.com/logseq/cljs-time";
        rev = "5704fbf48d3478eedcf24d458c8964b3c2fd59a9";
        sha256 = "0s6p73s9iqqx8qhigpkrnzpg3900l99gzjfy9idhiv1647wln2i0";
      };
      paths = map (path: src + path) [
        "/src"
      ];
    })

    rec {
      name = "core.match/org.clojure";
      src = fetchMavenArtifact {
        inherit repos;
        artifactId = "core.match";
        groupId = "org.clojure";
        sha512 = "52ada3bbe73ed1b429be811d3990df0cdb3e9d50f2a6c92b70d490a8ea922d4794da93c3b7487653f801954fc599704599b318b4d7926a9594583df37c55e926";
        version = "1.0.0";

      };
      paths = [ src ];
    }

    rec {
      name = "tools.reader/org.clojure";
      src = fetchMavenArtifact {
        inherit repos;
        artifactId = "tools.reader";
        groupId = "org.clojure";
        sha512 = "3481259c7a1eac719db2921e60173686726a0c2b65879d51a64d516a37f6120db8ffbb74b8bd273404285d7b25143ab5c7ced37e7c0eaf4ab1e44586ccd3c651";
        version = "1.3.6";

      };
      paths = [ src ];
    }

    rec {
      name = "sci/org.babashka";
      src = fetchMavenArtifact {
        inherit repos;
        artifactId = "sci";
        groupId = "org.babashka";
        sha512 = "d2726a04466fd78df77d1433bf0c9a86c8eb5451e01ab49e601eb566f2cb4dc0d2b62895b029318abcba76e5a93b23c9b774746943dee52bae663b084a8d8bfe";
        version = "0.3.2";

      };
      paths = [ src ];
    }

    rec {
      name = "rewrite-edn/borkdude";
      src = fetchMavenArtifact {
        inherit repos;
        artifactId = "rewrite-edn";
        groupId = "borkdude";
        sha512 = "65de37e272f905393eea4bcc4cc361fd2140d3d0c4065c58c262b2441a6bf93fe8aba548419b13167c8bda4a84b3dfe50886c0afc1b006b1065edcf6007f2cea";
        version = "0.4.7";

      };
      paths = [ src ];
    }

    rec {
      name = "jsoup/org.jsoup";
      src = fetchMavenArtifact {
        inherit repos;
        artifactId = "jsoup";
        groupId = "org.jsoup";
        sha512 = "8760893c3f516ea293ac7ba3092466f19e4665418b44c9cac7fa27d273164086f14eb9ce28744d3e9e8fadae924ecc906dca1663450f6fe3ff8c1f00d7bcc61c";
        version = "1.15.2";

      };
      paths = [ src ];
    }

    rec {
      name = "datascript/datascript";
      src = fetchMavenArtifact {
        inherit repos;
        artifactId = "datascript";
        groupId = "datascript";
        sha512 = "f7cafa71d59b151a35df87dbe6f144badb5223382f1a6ba095789e1a3ef3c9768383c680c439fc133bbfa25ae2f71f70e7042e780769f9c35d9bc03207b0de62";
        version = "1.5.3";

      };
      paths = [ src ];
    }

    rec {
      name = "tongue/tongue";
      src = fetchMavenArtifact {
        inherit repos;
        artifactId = "tongue";
        groupId = "tongue";
        sha512 = "54f64f8c8a6edee4e7b828e96d037db9fb8423a5beccbfa35191956e7ebdddc1affad5267b2ab03f9c9f9d8c91c7f419c7ca9920dcb64caf9bcbf15a6fd160f6";
        version = "0.4.4";

      };
      paths = [ src ];
    }

    rec {
      name = "nrepl/nrepl";
      src = fetchMavenArtifact {
        inherit repos;
        artifactId = "nrepl";
        groupId = "nrepl";
        sha512 = "62154bd5c58b3fd315431e269d8e30a1aded912b414dac57d0fcffba740daa451238311523f8307a3bed18afbf0d3e60cac64eb3d5f54bb04f7786e8d4fa8a93";
        version = "0.9.0";

      };
      paths = [ src ];
    }

    rec {
      name = "hickory/org.clj-commons";
      src = fetchMavenArtifact {
        inherit repos;
        artifactId = "hickory";
        groupId = "org.clj-commons";
        sha512 = "4bb195c6bf0dd2dad32ca70ee48d27428df4dcbe6b9e842dd428ed2d6499c38671536377ac5ddee095d019d957fbb64d3e0d7291fdc44549c12f61012a3b43f8";
        version = "0.7.3";

      };
      paths = [ src ];
    }

    rec {
      name = "slf4j-api/org.slf4j";
      src = fetchMavenArtifact {
        inherit repos;
        artifactId = "slf4j-api";
        groupId = "org.slf4j";
        sha512 = "e5435852569dda596ba46138af8ee9c4ecba8a7a43f4f1e7897aeb4430523a0f037088a7b63877df5734578f19d331f03d7b0f32d5ae6c425df211947b3e6173";
        version = "1.7.30";

      };
      paths = [ src ];
    }

    rec {
      name = "xnio-api/org.jboss.xnio";
      src = fetchMavenArtifact {
        inherit repos;
        artifactId = "xnio-api";
        groupId = "org.jboss.xnio";
        sha512 = "eab8904c5e2f6071f076e5f68fc7520fb4e9f292df2cc03be4ac7834f52994e9f539b52be7509280f4fb49a4ded185732e8a50ffd3417e39b540d508db34ac5f";
        version = "3.8.0.Final";

      };
      paths = [ src ];
    }

    rec {
      name = "dommy/prismatic";
      src = fetchMavenArtifact {
        inherit repos;
        artifactId = "dommy";
        groupId = "prismatic";
        sha512 = "753da7afbf48c1d203b09a71b865995879bfabf1473fe7b42ee0ce62673e75412265679962ca464b752b922104bcd30e08f8952f690f143bbd500d8697de0f51";
        version = "1.1.0";

      };
      paths = [ src ];
    }

    rec {
      name = "closure-compiler-unshaded/com.google.javascript";
      src = fetchMavenArtifact {
        inherit repos;
        artifactId = "closure-compiler-unshaded";
        groupId = "com.google.javascript";
        sha512 = "120085b36288008055e5d84a2f4fdb8c6ae4850724fdf6ae874c165e24443a93ac9fefc17fe490f634b26d048f467c5945d4f835d9bd2db50dd25473701dab91";
        version = "v20220502";

      };
      paths = [ src ];
    }

    rec {
      name = "test.check/org.clojure";
      src = fetchMavenArtifact {
        inherit repos;
        artifactId = "test.check";
        groupId = "org.clojure";
        sha512 = "b8d7a330b0b5514cd6a00c4382052fab51c3c9d3bc53133f8506791fa670e7c5ecd65094977ea5ced91f59623b0abd1ab8feeec96d63c5c6e459b265a655c577";
        version = "1.1.1";

      };
      paths = [ src ];
    }

    rec {
      name = "reitit-frontend/metosin";
      src = fetchMavenArtifact {
        inherit repos;
        artifactId = "reitit-frontend";
        groupId = "metosin";
        sha512 = "5a3dae8315e2c138fd52e76717963870660a096d2b4e5c35336331e6bbd3d9766c17227139e39938836f6253a56c08d37219be71b7ed495f2a47fd0ff3930c17";
        version = "0.3.10";

      };
      paths = [ src ];
    }

    rec {
      name = "core.memoize/org.clojure";
      src = fetchMavenArtifact {
        inherit repos;
        artifactId = "core.memoize";
        groupId = "org.clojure";
        sha512 = "67196537084b7cc34a01454d2a3b72de3fddce081b72d7a6dc1592d269a6c2728b79630bd2d52c1bf2d2f903c12add6f23df954c02ef8237f240d7394ccc3dde";
        version = "1.0.253";

      };
      paths = [ src ];
    }

    rec {
      name = "camel-snake-kebab/camel-snake-kebab";
      src = fetchMavenArtifact {
        inherit repos;
        artifactId = "camel-snake-kebab";
        groupId = "camel-snake-kebab";
        sha512 = "589d34b500560b7113760a16bfb6f0ccd8f162a1ce8c9bc829495432159ba9c95aebf6bc43aa126237a0525806a205a05f9910122074902b659e7fd151d176b1";
        version = "0.4.2";

      };
      paths = [ src ];
    }

    rec {
      name = "data.priority-map/org.clojure";
      src = fetchMavenArtifact {
        inherit repos;
        artifactId = "data.priority-map";
        groupId = "org.clojure";
        sha512 = "bb8bc5dbfd3738c36b99a51880ac3f1381d6564e67601549ef5e7ae2b900e53cdcdfb8d0fa4bf32fb8ebc4de89d954bfa3ab7e8a1122bc34ee5073c7c707ac13";
        version = "1.1.0";

      };
      paths = [ src ];
    }

    rec {
      name = "piggieback/cider";
      src = fetchMavenArtifact {
        inherit repos;
        artifactId = "piggieback";
        groupId = "cider";
        sha512 = "8b7b62c6babe21764363e61259800fca25a3db175d3b7f9ff77deec457618a3303162a7645179f95e9d7c7f02c7ffcb58d1e0e237623a35b24e583fb75bb3081";
        version = "0.5.3";

      };
      paths = [ src ];
    }

    rec {
      name = "boot-cljs-test/crisptrutski";
      src = fetchMavenArtifact {
        inherit repos;
        artifactId = "boot-cljs-test";
        groupId = "crisptrutski";
        # This version doesn't exist on CDN:
        #sha512 = "eea310cdd415714d61d0b9810d5c320075694496511160c35ac5a33aea3f2c409e9996b13c9ee45acf58e510c2b31f8705ddec5de3940cb39c2d0e44cc988271";
        #version = "0.2.2-20160402.204547-3";
        # Using this instead:
        sha512 = "sha512-fuGZoSUd8+6UQr8G6J88E2iSPGKfiErQIXZlmJPnvdm08sgBtc3HK7YTI8AMff2Cog3dvEZF98t5JGY14wTX4Q==";
        version = "0.2.2";

      };
      paths = [ src ];
    }

    rec {
      name = "shadow-undertow/thheller";
      src = fetchMavenArtifact {
        inherit repos;
        artifactId = "shadow-undertow";
        groupId = "thheller";
        sha512 = "dbf6e4e49f4fcbfc0b228ec9801cc62bbab6586fa082b10c7c8e16022a7cb93469c663ee98e4a61ce5a3369fda659e4a761442b380a9ecb00fb469b03cca16e4";
        version = "0.2.1";

      };
      paths = [ src ];
    }

    rec {
      name = "sci.impl.reflector/borkdude";
      src = fetchMavenArtifact {
        inherit repos;
        artifactId = "sci.impl.reflector";
        groupId = "borkdude";
        sha512 = "c747fd347e6aba9578d105298b7c7402f53e8639d5c8e6dc83b127f3c413feeb1b9dead7405ac2c4345f02290902e8a2affbec749474481e9c9f19b3d049f18f";
        version = "0.0.1";

      };
      paths = [ src ];
    }

    rec {
      name = "ring-core/ring";
      src = fetchMavenArtifact {
        inherit repos;
        artifactId = "ring-core";
        groupId = "ring";
        sha512 = "d2b4794dc025dbf49f0ff30681b2931b313736cb19ca8716b1bb6dcc35fdce09eaded45dd938981a170816062b6a59f4d2eed1767db4447923954e7d9d06f1fb";
        version = "1.9.5";

      };
      paths = [ src ];
    }

    rec {
      name = "core.cache/org.clojure";
      src = fetchMavenArtifact {
        inherit repos;
        artifactId = "core.cache";
        groupId = "org.clojure";
        sha512 = "0a07ceffc2fa3a536b23773eefc7ef5e1108913b93c3a5416116a6566de76dd5c218f3fb0cc19415cbaa8843838de310b76282f20bf1fc3467006c9ec373667e";
        version = "1.0.225";

      };
      paths = [ src ];
    }

    rec {
      name = "meta-merge/meta-merge";
      src = fetchMavenArtifact {
        inherit repos;
        artifactId = "meta-merge";
        groupId = "meta-merge";
        sha512 = "079339d69a18e88a7cf5ce37e29bf7d9b25c93011866fac3012b11444f9e3d69f4dc017a3e88ad20faa790b38e343e0b71e9e11c44028434da3f368f377e4458";
        version = "1.0.0";

      };
      paths = [ src ];
    }

    rec {
      name = "medley/medley";
      src = fetchMavenArtifact {
        inherit repos;
        artifactId = "medley";
        groupId = "medley";
        sha512 = "2f8782230ae26e5710b3c690576f8af04c12950be31581c1e5c8cfde1519ffb409d688d78250ca45236f05ea8144f3a863e048b0d9c27eb9dc68a640b63fc8f1";
        version = "1.4.0";

      };
      paths = [ src ];
    }

    rec {
      name = "hiccups/hiccups";
      src = fetchMavenArtifact {
        inherit repos;
        artifactId = "hiccups";
        groupId = "hiccups";
        sha512 = "aea52df313d89fa846f8ebe5881c11329c17e096047fbbc9367d161092b64435f464e344b4f3cf88ce703c37aebf3aed9e817c82bb29a2b49fc83711d39f84bd";
        version = "0.3.0";

      };
      paths = [ src ];
    }

    rec {
      name = "core.async/org.clojure";
      src = fetchMavenArtifact {
        inherit repos;
        artifactId = "core.async";
        groupId = "org.clojure";
        sha512 = "6c80a6ff6fe7ec8503c36a97684e4118ee1b103983b68c8ce21a398661ede02255e4b04a16fbabd112c8d57b7dd28967f6708e8d3461a5a393e019cda7ca4e96";
        version = "1.6.673";

      };
      paths = [ src ];
    }

    rec {
      name = "jaxb-api/javax.xml.bind";
      src = fetchMavenArtifact {
        inherit repos;
        artifactId = "jaxb-api";
        groupId = "javax.xml.bind";
        sha512 = "0c5bfc2c9f655bf5e6d596e0c196dcb9344d6dc78bf774207c8f8b6be59f69addf2b3121e81491983eff648dfbd55002b9878132de190825dad3ef3a1265b367";
        version = "2.3.0";

      };
      paths = [ src ];
    }

  ];
}
