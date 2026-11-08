import 'package:flutter/material.dart';

import '../contract/contract.dart';

const statusLabel = {
  SurveyStatus.not_started: 'Not started',
  SurveyStatus.in_progress: 'In progress',
  SurveyStatus.submitted: 'Submitted',
  SurveyStatus.approved: 'Approved',
  SurveyStatus.needs_rework: 'Needs rework',
};

const statusColor = {
  SurveyStatus.not_started: Color(0xFF6B7280),
  SurveyStatus.in_progress: Color(0xFF2563EB),
  SurveyStatus.submitted: Color(0xFF16A34A),
  SurveyStatus.approved: Color(0xFF15803D),
  SurveyStatus.needs_rework: Color(0xFFDC2626),
};

class StatusChip extends StatelessWidget {
  const StatusChip({super.key, required this.status});

  final SurveyStatus status;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: statusColor[status],
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          statusLabel[status]!,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      );
}
