enum ContactStage {
  newContact,
  followup24h,
  followup7d,
  followup30d,
  qualified,
}

ContactStage contactStageFromString(String? str) {
  switch (str) {
    case 'new':
    case 'newContact':
      return ContactStage.newContact;
    case 'followup_24h':
    case 'followup24h':
      return ContactStage.followup24h;
    case 'followup_7d':
    case 'followup7d':
      return ContactStage.followup7d;
    case 'followup_30d':
    case 'followup30d':
      return ContactStage.followup30d;
    case 'qualified':
      return ContactStage.qualified;
    default:
      return ContactStage.newContact;
  }
}

extension ContactStageExtension on ContactStage {
  String toShortString() {
    switch (this) {
      case ContactStage.newContact:
        return 'new';
      case ContactStage.followup24h:
        return 'followup_24h';
      case ContactStage.followup7d:
        return 'followup_7d';
      case ContactStage.followup30d:
        return 'followup_30d';
      case ContactStage.qualified:
        return 'qualified';
    }
  }

  int get index {
    switch (this) {
      case ContactStage.newContact:
        return 0;
      case ContactStage.followup24h:
        return 1;
      case ContactStage.followup7d:
        return 2;
      case ContactStage.followup30d:
        return 3;
      case ContactStage.qualified:
        return 4;
    }
  }
}
