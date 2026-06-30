import 'package:code_assets/code_assets.dart';
import 'package:hooks/hooks.dart';
import 'package:path/path.dart' as path;

void main(List<String> args) async {
  await build(args, (input, output) async {
    output.assets.code.add(
      CodeAsset(
        package: input.packageName,
        name: 'rust/frb_generated.io.dart',
        linkMode: DynamicLoadingBundled(),
        file: input.packageRoot.resolve('rust/target/release/librust_lib_aria.so'),
      ),
    );
  });
}
