#!/usr/bin/env -S PYTHONPATH=../../../tools/extract-utils python3
#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

from extract_utils.fixups_blob import (
    blob_fixup,
    blob_fixups_user_type,
    run_cmd
)

from extract_utils.fixups_lib import (
    lib_fixups,
    lib_fixups_user_type,
)

from extract_utils.main import (
    ExtractUtils,
    ExtractUtilsModule,
)

from extract_utils.tools import (
    DEFAULT_PATCHELF_VERSION,
    patchelf_version_path_map,
)

namespace_imports = [
    'device/samsung/s5e8845-common',
    'vendor/samsung/s5e8845-common',
    'hardware/samsung_slsi-linaro/exynos',
    'hardware/samsung_slsi-linaro/graphics',
    'hardware/samsung_slsi-linaro/sgpu',
]

def rename_dynamic_symbol(
    _ctx: BlobFixupCtx,
    _file: File,
    file_path: str,
    old_name: str,
    new_name: str,
    **_kwargs,
):
    with tempfile.NamedTemporaryFile(mode='w', encoding='utf-8') as tmp:
        tmp.write(f'{old_name} {new_name}')
        tmp.flush()
        run_cmd(
            [
                patchelf_version_path_map[DEFAULT_PATCHELF_VERSION],
                '--rename-dynamic-symbols',
                tmp.name,
                file_path,
            ]
        )

blob_fixups: blob_fixups_user_type = {
   (
        'vendor/lib64/hw/audio.primary.s5e8845.so',
        'vendor/lib64/libaudioproxy2.so',
        'vendor/lib64/libaudioparamupdate.so',
    ): blob_fixup()
        .replace_needed('libaudioroute.so', 'libaudioroute_samsung.so')
        .replace_needed('libtinyalsa.so', 'libtinyalsa_samsung.so'),
    'vendor/bin/hermesd': blob_fixup()
        .binary_regex_replace(b'security.securehw.available', b'vendor.s.securehw.available')
        .binary_regex_replace(b'security.securenvm.available', b'vendor.s.securenvm.available'),
    'vendor/lib64/libskeymint_cli.so': blob_fixup()
        .call(rename_dynamic_symbol, 'OPENSSL_sk_delete', 'sk_delete')
        .call(rename_dynamic_symbol, 'OPENSSL_sk_dup', 'sk_dup')
        .replace_needed('libcrypto.so', 'libcrypto-v33.so'),
    'vendor/etc/init/android.hardware.security.keymint-service.samsung.rc': blob_fixup()
        .regex_replace('-service', '-service.samsung'),
    (
        'vendor/lib64/libalsautils_sec.so',
        'vendor/lib64/libaudioroute_samsung.so',
    ): blob_fixup()
        .replace_needed('libtinyalsa.so', 'libtinyalsa_samsung.so'),
}  # fmt: skip

module = ExtractUtilsModule(
    's5e8845-common',
    'samsung',
    namespace_imports=namespace_imports,
    blob_fixups=blob_fixups,
    lib_fixups=lib_fixups,
)

if __name__ == '__main__':
    utils = ExtractUtils.device(module)
    utils.run()
