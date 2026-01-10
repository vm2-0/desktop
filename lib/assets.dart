import 'package:flutter/material.dart';

class Assets {
  static const String assetFolder = 'assets/';
  static const String assetIconsFolder = '${assetFolder}icons/';
  static const String assetMenuFolder = '${assetFolder}menus/';

  static const String background = '${assetFolder}main-background.png';
  static const String logo = '${assetFolder}Logo-Circle-Transparent.svg';
  static const String logoWhite = '${assetFolder}icons-app/icon-white.png';

  // Icons
  static const String homeIcon = '${assetIconsFolder}home_icon.png';
  static const String forgeIcon = '${assetIconsFolder}forge_icon.png';
  static const String farmerIcon = '${assetIconsFolder}farmer_icon.png';
  static const String farmerHistoryIcon =
      '${assetIconsFolder}farmer_history_icon.png';
  static const String factoryAddIcon =
      '${assetIconsFolder}add_factory_icon.png';
  static const String statsIcon = '${assetIconsFolder}stats_icon.png';
  static const String referralIcon = '${assetIconsFolder}referral_icon.png';
  static const String walletToConnectIcon =
      '${assetIconsFolder}wallet_to_connect_icon.png';
  static const String walletToConnectIconWB =
      '${assetIconsFolder}wallet_to_connect_wb_icon.png';
  static const String walletConnectedIcon =
      '${assetIconsFolder}wallet_connected_icon.png';
  static const String deleteIcon = '${assetIconsFolder}delete_icon.png';
  static const String editIcon = '${assetIconsFolder}edit_icon.png';
  static const String recordIcon = '${assetIconsFolder}record_icon.png';
  static const String uploadIcon = '${assetIconsFolder}upload_icon.png';

  static const String factoryGeneralIcon =
      '${assetIconsFolder}factory_general_icon.png';
  static const String factoryTasksIcon =
      '${assetIconsFolder}factory_tasks_icon.png';
  static const String factoryDemosIcon =
      '${assetIconsFolder}factory_demos_icon.png';
  static const String factoryDatasetsIcon =
      '${assetIconsFolder}factory_datasets_icon.png';

  // Menu
  static const String menuFarm = '${assetMenuFolder}farmer_menu.png';
  static const String menuForge = '${assetMenuFolder}forge_menu.png';
  static const String getReferralCodeMenu =
      '${assetMenuFolder}get_referral_code_menu.png';
}

class ClonesFonts {
  static TextStyle getPrimaryFont({
    double? fontSize,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
    Color? color,
    double? letterSpacing,
    double? height,
  }) {
    return TextStyle(
      fontFamily: 'Inter',
      fontSize: fontSize ?? 16,
      fontWeight: fontWeight ?? FontWeight.normal,
      color: color,
      fontStyle: fontStyle ?? FontStyle.normal,
      letterSpacing: letterSpacing,
      height: height,
    );
  }

  static TextStyle getMonoFont({
    double? fontSize,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
    Color? color,
    double? letterSpacing,
    double? height,
  }) {
    return TextStyle(
      fontFamily: 'JetBrains Mono',
      fontSize: fontSize ?? 14,
      fontWeight: fontWeight ?? FontWeight.normal,
      color: color,
      fontStyle: fontStyle ?? FontStyle.normal,
      letterSpacing: letterSpacing,
      height: height,
    );
  }
}

class ClonesColors {
  static const Color primaryText = Colors.white;
  static Color secondaryText = Colors.white.withValues(alpha: 0.6);
  static const Color primary = Color(0xFF9E72FF);
  static const Color secondary = Color(0xFF9050FF);
  static const Color tertiary = Color(0xFF5C51FF);
  static const Color error = Color(0xFFFB923C);
  static const Color important = Color(0xFFFB923C);

  static const Color rewardInfo = Color(0xFF10B981);
  static const Color rewardInfoClaimed = Color(0xFF10B981);
  static const Color rewardInfoShouldBeClaimed = Color(0xFFF472B6);
  static const Color uploadLimit = Color.fromARGB(255, 203, 132, 46);

  static Gradient gradientBtnPrimary = const LinearGradient(
    colors: [
      Color(0xFFB99AFF),
      Color(0xFF844BFF),
    ],
  );

  static Gradient gradientInputFormBackground = LinearGradient(
    colors: [
      const HSLColor.fromAHSL(1, 0, 0, 0.10).toColor().withValues(alpha: 1),
      const HSLColor.fromAHSL(1, 0, 0, 0.10).toColor().withValues(alpha: 0.3),
    ],
    stops: const [0, 1],
  );

  static const Color containerIcon1 = Color(0xFFF472B6);
  static const Color containerIcon2 = Color(0xFF22D3EE);
  static const Color containerIcon3 = Color(0xFFFB923C);
  static const Color containerIcon4 = Color(0xFF4ADE80);
  static const Color containerIcon5 = Color(0xFF8B5CF6);
  static const Color containerIcon6 = Color(0xFFEC4899);

  static const Color lowScore = Color(0xFFFB923C);
  static const Color mediumScore = Color(0xFF22D3EE);
  static const Color highScore = Color(0xFF4ADE80);

  static Color getScoreColor(int score) {
    if (score < 50) {
      return lowScore;
    } else if (score < 80) {
      return mediumScore;
    } else {
      return highScore;
    }
  }

  static const Color eventTypeFFMPEGStderr = Colors.deepOrange;
  static const Color eventTypeMouseMove = Colors.blue;
  static const Color eventTypeMouseUp = Colors.purple;
  static const Color eventTypeMouseDown = Colors.teal;
  static const Color eventTypeMouseWheel = Colors.indigoAccent;
  static const Color eventTypeKeyDown = Colors.yellow;
  static const Color eventTypeKeyUp = Colors.lightGreen;
  static const Color eventAxtree = Colors.lightGreenAccent;

  static Color getEventTypeColor(String eventType) {
    switch (eventType) {
      case 'ffmpeg_stderr':
        return eventTypeFFMPEGStderr;
      case 'mousemove':
        return eventTypeMouseMove;
      case 'mouseup':
        return eventTypeMouseUp;
      case 'mousedown':
        return eventTypeMouseDown;
      case 'mousewheel':
        return eventTypeMouseWheel;
      case 'keydown':
        return eventTypeKeyDown;
      case 'keyup':
        return eventTypeKeyUp;
      case 'axtree':
        return eventAxtree;
      default:
        return Colors.white;
    }
  }
}
