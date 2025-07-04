#!/bin/bash
# @note HTC Desire / Motorola Milestone 등의 버그로 v7에서도 armeabi를 로드하여 armeabi에 이름을 바꿔 넣음
# @see http://groups.google.com/group/android-ndk/browse_thread/thread/464bab5543c672d4

# API 21이전에는 libc.so에 rand, atof등의 함수가 누락되어있어 x86_64를 제외하고는 API 16을 사용한다.

TARGET=$1
COPY=0
BUILD=0
PROFILE=0
PLATFORM=21
DEBUG_BUILD=0
# build type, release 0, debug 1, debug type is friendly for crash resolving.
# we can build debug type firstly, if .so library is stable, then we can build release type.
if [ -z ${ENV_DEBUG_BUILD} ] || [ ${ENV_DEBUG_BUILD} == '0' ]
then
  DEBUG_BUILD=0
else
  DEBUG_BUILD=1
fi

# just keep this to 0, we introduce another flag for log output. E_MX_LOG_ENABLE
#
E_VERBOSE=0

if [ -z ${ENV_MX_LOG} ] || [ ${ENV_MX_LOG} == '0' ]
then
E_MX_LOG_ENABLE=0
else
E_MX_LOG_ENABLE=1
fi


if [ -z ${ENV_MX_UNIT_TEST} ] || [ ${ENV_MX_UNIT_TEST} == '0' ]
then
E_MX_UNIT_TEST=0
else
E_MX_UNIT_TEST=1
fi

echo "DEBUG_BUILD=${DEBUG_BUILD} E_MX_LOG_ENABLE=${E_MX_LOG_ENABLE} E_MX_UNIT_TEST=${E_MX_UNIT_TEST}"

ROOT=$(cd "$(dirname "$0")"; pwd)
source ${ROOT}/util.sh


MAKE=$NDK/ndk-build

prepare()
{
	rm -r ../obj/local
}

prepare_mips()
{
	rm -r ../obj/local
}

prepare_x86()
{
	rm -r ../obj/local
}

prepare_x86_64()
{
	rm -r ../obj/local
}

# MIPS32 revision 2
mips32r2()
{
  RELEASE_DIR=$(get_release_dir mips)
	if [ $BUILD -eq 1 ]
	then
		echo -ne '\nBUILDING '$TARGET'.MIPS32 rev.2...\n\n'
		prepare_mips
		$MAKE NDK_DEBUG=$DEBUG_BUILD \
				  -j$CPU_CORE \
				  -e APP_ABI=mips \
				  -e MX_DEBUG=$DEBUG_BUILD \
          -e MX_LOG_ENABLE=$E_MX_LOG_ENABLE \
          -e MX_UNIT_TEST=$E_MX_UNIT_TEST \
				  -e VERBOSE_MODE=$E_VERBOSE \
				  -e APP_PLATFORM=android-$PLATFORM \
				  -e LINK_AGAINST=15-mips \
				  -e APP_BUILD_SCRIPT=a-$TARGET.mk \
				  -e ARCH=mips32r2 \
				  -e NDK_APP_DST_DIR=libs/mips \
				  -e NDK_BH_DIR=blackHole/libs/mips \
				  -e LIB_RELEASE_DIR=$RELEASE_DIR \
				  -e NAME=$TARGET \
				  -e PROFILE=$PROFILE

		dieOnError
	fi
}

x86_64()
{
  RELEASE_DIR=$(get_release_dir x86_64)
	if [ $BUILD -eq 1 ]
	then
		echo -ne '\nBUILDING '$TARGET'.x86_64...\n\n'
		prepare_x86_64
		$MAKE NDK_DEBUG=$DEBUG_BUILD \
				  -j$CPU_CORE \
				  -e APP_ABI=x86_64 \
				  -e MX_DEBUG=$DEBUG_BUILD \
          -e MX_LOG_ENABLE=$E_MX_LOG_ENABLE \
          -e MX_UNIT_TEST=$E_MX_UNIT_TEST \
				  -e VERBOSE_MODE=$E_VERBOSE \
				  -e APP_PLATFORM=android-$PLATFORM \
				  -e LINK_AGAINST=21-x86_64 \
				  -e APP_BUILD_SCRIPT=a-$TARGET.mk \
				  -e ARCH=atom \
				  -e NDK_APP_DST_DIR=libs/x86_64 \
				  -e NDK_BH_DIR=blackHole/libs/x86_64 \
				  -e LIB_RELEASE_DIR=$RELEASE_DIR \
				  -e NAME=$TARGET \
				  -e PROFILE=$PROFILE

		dieOnError
	fi
}

# x86 (Atom)
x86()
{
  RELEASE_DIR=$(get_release_dir x86)
	if [ $BUILD -eq 1 ]
	then
		echo -ne '\nBUILDING '$TARGET'.x86 Atom...\n\n'
		prepare_x86
		$MAKE NDK_DEBUG=$DEBUG_BUILD \
				  -j$CPU_CORE \
				  -e APP_ABI=x86 \
				  -e MX_DEBUG=$DEBUG_BUILD \
          -e MX_LOG_ENABLE=$E_MX_LOG_ENABLE \
          -e MX_UNIT_TEST=$E_MX_UNIT_TEST \
				  -e VERBOSE_MODE=$E_VERBOSE \
				  -e APP_PLATFORM=android-$PLATFORM \
				  -e LINK_AGAINST=16-x86 \
				  -e APP_BUILD_SCRIPT=a-$TARGET.mk \
				  -e ARCH=atom \
				  -e NDK_APP_DST_DIR=libs/x86 \
				  -e NDK_BH_DIR=blackHole/libs/x86 \
				  -e LIB_RELEASE_DIR=$RELEASE_DIR \
				  -e NAME=$TARGET \
				  -e PROFILE=$PROFILE

		dieOnError
	fi
}

# x86 (sse2)
x86_sse2()
{
  RELEASE_DIR=$(get_release_dir x86)
	if [ $BUILD -eq 1 ]
	then
		echo -ne '\nBUILDING '$TARGET'.x86 SSE2...\n\n'
		prepare_x86
		$MAKE NDK_DEBUG=$DEBUG_BUILD \
				  -j$CPU_CORE \
				  -e APP_ABI=x86 \
				  -e MX_DEBUG=$DEBUG_BUILD \
          -e MX_LOG_ENABLE=$E_MX_LOG_ENABLE \
          -e MX_UNIT_TEST=$E_MX_UNIT_TEST \
				  -e VERBOSE_MODE=$E_VERBOSE \
				  -e APP_PLATFORM=android-$PLATFORM \
				  -e LINK_AGAINST=16-x86 \
				  -e APP_BUILD_SCRIPT=a-$TARGET.mk \
				  -e ARCH=i686 \
				  -e NDK_APP_DST_DIR=libs/x86-sse2 \
				  -e NDK_BH_DIR=blackHole/libs/x86-sse2 \
				  -e LIB_RELEASE_DIR=$RELEASE_DIR \
				  -e NAME=$TARGET \
				  -e PROFILE=$PROFILE

		dieOnError
	fi
}

arm64()
{
  RELEASE_DIR=$(get_release_dir arm64)
	if [ $BUILD -eq 1 ]
	then
		echo -ne '\nBUILDING '$TARGET'.arm64...\n\n'
		prepare
		$MAKE NDK_DEBUG=$DEBUG_BUILD \
				  -j$CPU_CORE \
				  -e APP_ABI=arm64-v8a \
				  -e MX_DEBUG=$DEBUG_BUILD \
				  -e MX_LOG_ENABLE=$E_MX_LOG_ENABLE \
				  -e MX_UNIT_TEST=$E_MX_UNIT_TEST \
				  -e VERBOSE_MODE=$E_VERBOSE \
				  -e APP_PLATFORM=android-$PLATFORM \
				  -e LINK_AGAINST=22-arm64 \
				  -e APP_BUILD_SCRIPT=a-$TARGET.mk \
				  -e ARCH=armv8-a \
				  -e VFP=neon \
				  -e NDK_APP_DST_DIR=libs/arm64-v8a \
				  -e NDK_BH_DIR=blackHole/libs/arm64-v8a \
				  -e LIB_RELEASE_DIR=$RELEASE_DIR \
				  -e NAME=$TARGET \
				  -e PROFILE=$PROFILE

		dieOnError
	fi

	if [ $COPY -eq 1 ]
	then
		cp libs/arm64-v8a/lib$TARGET.so libs/output/videoplayer/arm64-v8a/
	fi
}

neon()
{
  RELEASE_DIR=$(get_release_dir neon)
	if [ $BUILD -eq 1 ]
	then
		echo -ne '\nBUILDING '$TARGET'.neon...\n\n'
		echo "debug build: $DEBUG_BUILD log enabled: $E_MX_LOG_ENABLE"
		prepare
		$MAKE NDK_DEBUG=$DEBUG_BUILD \
				  -j$CPU_CORE \
				  -e APP_ABI=armeabi-v7a \
				  -e MX_DEBUG=$DEBUG_BUILD \
          -e MX_LOG_ENABLE=$E_MX_LOG_ENABLE \
          -e MX_UNIT_TEST=$E_MX_UNIT_TEST \
				  -e VERBOSE_MODE=$E_VERBOSE \
				  -e APP_PLATFORM=android-$PLATFORM \
				  -e LINK_AGAINST=16-arm \
				  -e APP_BUILD_SCRIPT=a-$TARGET.mk \
				  -e ARCH=armv7-a \
				  -e VFP=neon \
				  -e NDK_APP_DST_DIR=libs/armeabi-v7a/neon \
				  -e NDK_BH_DIR=blackHole/libs/armeabi-v7a \
				  -e LIB_RELEASE_DIR=$RELEASE_DIR \
				  -e NAME=$TARGET \
				  -e PROFILE=$PROFILE

		dieOnError
	fi

	if [ $COPY -eq 1 ]
	then
		cp libs/armeabi-v7a/neon/lib$TARGET.so libs/output/videoplayer/armeabi-v7a/
	fi
}

tegra3()
{
  RELEASE_DIR=$(get_release_dir tegra3)
	if [ $BUILD -eq 1 ]
	then
		echo -ne '\nBUILDING '$TARGET'.tegra3...\n\n'
		prepare
		$MAKE NDK_DEBUG=$DEBUG_BUILD \
				  -j$CPU_CORE \
				  -e APP_ABI=armeabi-v7a \
				  -e MX_DEBUG=$DEBUG_BUILD \
          -e MX_LOG_ENABLE=$E_MX_LOG_ENABLE \
          -e MX_UNIT_TEST=$E_MX_UNIT_TEST \
				  -e VERBOSE_MODE=$E_VERBOSE \
				  -e APP_PLATFORM=android-$PLATFORM \
				  -e LINK_AGAINST=16-arm \
				  -e APP_BUILD_SCRIPT=a-$TARGET.mk \
				  -e ARCH=armv7-a \
				  -e VFP=neon \
				  -e UNALIGNED_ACCESS=0 \
				  -e NDK_APP_DST_DIR=libs/armeabi-v7a/tegra3 \
				  -e NDK_BH_DIR=blackHole/libs/armeabi-v7a/tegra3 \
				  -e LIB_RELEASE_DIR=$RELEASE_DIR \
				  -e NAME=$TARGET \
				  -e PROFILE=$PROFILE

#				  -e NDK_TOOLCHAIN_VERSION=4.9
#				  -e OLD_FFMPEG=1 \
#				  -e FFMPEG_SUFFIX=__1.7.39
    dieOnError
	fi

	if [ $COPY -eq 1 ]
	then
		cp libs/armeabi-v7a/tegra3/lib$TARGET.so libs/output/videoplayer/armeabi-v7a/
	fi
}

# ARMv7a + VFPv3-D16 (tegra2)
tegra2()
{
  RELEASE_DIR=$(get_release_dir tegra2)
	if [ $BUILD -eq 1 ]
	then
		prepare
		echo -ne '\nBUILDING '$TARGET'.tegra2...\n\n'
		$MAKE NDK_DEBUG=$DEBUG_BUILD \
				  -j$CPU_CORE \
				  -e APP_ABI=armeabi-v7a \
				  -e MX_DEBUG=$DEBUG_BUILD \
          -e MX_LOG_ENABLE=$E_MX_LOG_ENABLE \
          -e MX_UNIT_TEST=$E_MX_UNIT_TEST \
				  -e VERBOSE_MODE=$E_VERBOSE \
				  -e APP_PLATFORM=android-$PLATFORM \
				  -e LINK_AGAINST=16-arm \
				  -e APP_BUILD_SCRIPT=a-$TARGET.mk \
				  -e ARCH=armv7-a \
				  -e VFP=vfpv3-d16 \
				  -e NDK_APP_DST_DIR=libs/armeabi-v7a/vfpv3-d16 \
				  -e NDK_BH_DIR=blackHole/libs/armeabi-v7a/vfpv3-d16 \
				  -e LIB_RELEASE_DIR=$RELEASE_DIR \
				  -e NAME=$TARGET \
				  -e PROFILE=$PROFILE

		dieOnError
	fi

	if [ $COPY -eq 1 ]
	then
		cp libs/armeabi-v7a/vfpv3-d16/lib$TARGET.so libs/output/videoplayer/armeabi-v7a
	fi
}

# ARMv7a
v7a()
{
  RELEASE_DIR=$(get_release_dir neon)
	if [ $BUILD -eq 1 ]
	then
		prepare
		echo -ne '\nBUILDING '$TARGET'.v7a...\n\n'
		$MAKE NDK_DEBUG=$DEBUG_BUILD \
				  -j$CPU_CORE \
				  -e APP_ABI=armeabi-v7a \
				  -e MX_DEBUG=$DEBUG_BUILD \
          -e MX_LOG_ENABLE=$E_MX_LOG_ENABLE \
          -e MX_UNIT_TEST=$E_MX_UNIT_TEST \
				  -e VERBOSE_MODE=$E_VERBOSE \
				  -e APP_PLATFORM=android-$PLATFORM \
				  -e LINK_AGAINST=16-arm \
				  -e APP_BUILD_SCRIPT=a-$TARGET.mk \
				  -e ARCH=armv7-a \
				  -e VFP=vfp \
				  -e NDK_APP_DST_DIR=libs/armeabi-v7a \
				  -e NDK_BH_DIR=blackHole/libs/armeabi-v7a \
				  -e LIB_RELEASE_DIR=$RELEASE_DIR \
				  -e NAME=$TARGET \
				  -e PROFILE=$PROFILE

		dieOnError
	fi

	if [ $COPY -eq 1 ]
	then
		cp libs/armeabi-v7a/lib$TARGET.so libs/output/videoplayer/armeabi-v7a
	fi
}

# ARMv6 + VFP
v6_vfp()
{
  RELEASE_DIR=$(get_release_dir neon)
	if [ $BUILD -eq 1 ]
	then
		prepare
		echo -ne '\nBUILDING '$TARGET'.v6+vfp...\n\n'
		$MAKE NDK_DEBUG=$DEBUG_BUILD \
				  -j$CPU_CORE \
				  -e APP_ABI=armeabi \
				  -e MX_DEBUG=$DEBUG_BUILD \
          -e MX_LOG_ENABLE=$E_MX_LOG_ENABLE \
          -e MX_UNIT_TEST=$E_MX_UNIT_TEST \
				  -e VERBOSE_MODE=$E_VERBOSE \
				  -e APP_PLATFORM=android-$PLATFORM \
				  -e LINK_AGAINST=16-arm \
				  -e APP_BUILD_SCRIPT=a-$TARGET.mk \
				  -e ARCH=armv6 \
				  -e VFP=vfp \
				  -e NDK_APP_DST_DIR=libs/armeabi-v6/vfp \
				  -e NDK_BH_DIR=blackHole/libs/armeabi-v6/vfp \
				  -e LIB_RELEASE_DIR=$RELEASE_DIR \
				  -e NAME=$TARGET \
				  -e PROFILE=$PROFILE

		dieOnError
	fi

	if [ $COPY -eq 1 ]
	then
		cp libs/armeabi-v6/vfp/lib$TARGET.so libs/output/videoplayer/armeabi
	fi
}

# ARMv6
v6()
{
  RELEASE_DIR=$(get_release_dir neon)
	if [ $BUILD -eq 1 ]
	then
		prepare
		echo -ne '\nBUILDING '$TARGET'.v6...\n\n'
		$MAKE NDK_DEBUG=$DEBUG_BUILD \
				  -j$CPU_CORE \
				  -e APP_ABI=armeabi \
				  -e MX_DEBUG=$DEBUG_BUILD \
          -e MX_LOG_ENABLE=$E_MX_LOG_ENABLE \
          -e MX_UNIT_TEST=$E_MX_UNIT_TEST \
				  -e VERBOSE_MODE=$E_VERBOSE \
				  -e APP_PLATFORM=android-$PLATFORM \
				  -e LINK_AGAINST=16-arm \
				  -e APP_BUILD_SCRIPT=a-$TARGET.mk \
				  -e ARCH=armv6 \
				  -e NDK_APP_DST_DIR=libs/armeabi-v6 \
				  -e NDK_BH_DIR=blackHole/libs/armeabi-v6 \
				  -e LIB_RELEASE_DIR=$RELEASE_DIR \
				  -e NAME=$TARGET \
				  -e PROFILE=$PROFILE

		dieOnError
	fi

	if [ $COPY -eq 1 ]
	then
		cp libs/armeabi-v6/lib$TARGET.so libs/output/videoplayer/armeabi
	fi
}

# ARMv5TE
v5te()
{
  RELEASE_DIR=$(get_release_dir neon)
	if [ $BUILD -eq 1 ]
	then
		prepare
		echo -ne '\nBUILDING '$TARGET'.v5te...\n\n'
		$MAKE NDK_DEBUG=$DEBUG_BUILD \
				  -j$CPU_CORE \
				  -e APP_ABI=armeabi \
				  -e MX_DEBUG=$DEBUG_BUILD \
          -e MX_LOG_ENABLE=$E_MX_LOG_ENABLE \
          -e MX_UNIT_TEST=$E_MX_UNIT_TEST \
				  -e VERBOSE_MODE=$E_VERBOSE \
				  -e APP_PLATFORM=android-$PLATFORM \
				  -e LINK_AGAINST=16-arm \
				  -e APP_BUILD_SCRIPT=a-$TARGET.mk \
				  -e ARCH=armv5te \
				  -e NDK_APP_DST_DIR=libs/armeabi-v5 \
				  -e NDK_BH_DIR=blackHole/libs/armeabi-v5 \
				  -e LIB_RELEASE_DIR=$RELEASE_DIR \
				  -e NAME=$TARGET \
				  -e PROFILE=$PROFILE

		dieOnError
	fi

	if [ $COPY -eq 1 ]
	then
		cp libs/armeabi-v5/lib$TARGET.so libs/output/videoplayer/armeabi
	fi
}


if [ $TARGET == 'mxvp' ]
then
	# /home/blue/workspace/GenSecureString/Debug/GenSecureString `pwd`/mxvp/android/sec_str
	docker run -it --rm -v `pwd`/../../GenSecureString/linux_bin/:/linux_bin -v `pwd`:/pwd ubuntu /linux_bin/GenSecureString /pwd/mxvp/android/sec_str
	# /home/blue/workspace/GenSecureBytes/Debug/GenSecureBytes `pwd`/mxvp/android/sec_bytes
	docker run -it --rm -v `pwd`/../../GenSecureBytes/linux_bin/:/linux_bin -v `pwd`:/pwd ubuntu /linux_bin/GenSecureBytes /pwd/mxvp/android/sec_bytes
fi

# @note 'then' should appear next line of [] block. 'do' for 'for' seems to be same.. i don't know why ..
#if [ $# -eq 1 ]
#then
#	COPY=1
#	BUILD=1
#	v7a
#else
	for p in $*
	do
		case "$p" in
			copy)
				COPY=1 ;;
			build)
				BUILD=1 ;;
		  release)
		    DEBUG_BUILD=0 ;;
			mips)
				mips32r2 ;;
			x86_64)
				x86_64 ;;
			x86)
				x86 ;;
			x86_sse2)
				x86_sse2 ;;
			arm64)
				arm64 ;;
			neon)
				neon ;;
			tegra3)
				tegra3;;
			tegra2)
				tegra2;;
			v7a)
				v7a;;
			v6_vfp)
				v6_vfp ;;
			v6)
				v6 ;;
			v5te)
				v5te ;;
			profile)
				PROFILE=1 ;;
			21)
				PLATFORM=21 ;;
			4.8)
				export NDK_TOOLCHAIN_VERSION=4.8 ;;
		esac
	done
#fi
