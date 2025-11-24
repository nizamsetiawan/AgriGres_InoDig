import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:agrigres/common/widgets/appbar/appbar.dart';
import 'package:agrigres/features/agri_info/models/dinas_pertanian_dataset_model.dart';
import 'package:agrigres/features/agri_info/models/dinas_pertanian_resource_data.dart';
import 'package:agrigres/data/repositories/agri_info/dinas_pertanian_repository.dart';
import 'package:agrigres/utils/helpers/loaders.dart';
import 'package:agrigres/utils/constraints/colors.dart';

class DinasPertanianResourceScreen extends StatefulWidget {
  final DinasPertanianDatasetModel dataset;
  final DinasPertanianResourceModel resource;

  const DinasPertanianResourceScreen({
    super.key,
    required this.dataset,
    required this.resource,
  });

  @override
  State<DinasPertanianResourceScreen> createState() =>
      _DinasPertanianResourceScreenState();
}

class _ResourceDiagramTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final Color textColor;
  final TextTheme textTheme;

  const _ResourceDiagramTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.textColor,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: textColor),
          const SizedBox(height: 6),
          Text(
            label,
            style: textTheme.bodySmall?.copyWith(
              color: textColor.withOpacity(0.75),
              fontSize: 10,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _DinasPertanianResourceScreenState
    extends State<DinasPertanianResourceScreen> {
  final DinasPertanianRepository _repository = Get.find();
  DinasPertanianResourceData _resourceData =
      DinasPertanianResourceData.empty();
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadResourceData();
  }

  Future<void> _loadResourceData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final data =
          await _repository.fetchResourceData(widget.resource.resourceId);
      setState(() {
        _resourceData = data;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
      TLoaders.errorSnackBar(
        title: 'Kesalahan',
        message: 'Tidak dapat memuat data resource',
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColors.light,
      appBar: TAppBar(
        title: Text(
          widget.resource.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        showBackArrow: true,
        actions: [
          IconButton(
            onPressed: _isLoading ? null : _loadResourceData,
            icon: _isLoading
                ? SizedBox(
                    width: 30,
                    height: 14,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        minHeight: 3,
                        color: TColors.primary,
                        backgroundColor: TColors.primary.withOpacity(0.2),
                      ),
                    ),
                  )
                : const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return Padding(
        padding: const EdgeInsets.only(top: 32),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                minHeight: 4,
                color: TColors.primary,
                backgroundColor: TColors.primary.withOpacity(0.15),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Memuat data resource...',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: TColors.textSecondary,
                  ),
            ),
          ],
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Text(
          _errorMessage!,
          style: const TextStyle(color: Colors.red),
        ),
      );
    }

    if (_resourceData.records.isEmpty) {
      return const Center(
        child: Text('Belum ada data yang tersedia untuk resource ini.'),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildMetaInfo(),
        const SizedBox(height: 16),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              color: TColors.white,
              child: _buildDataTable(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMetaInfo() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: TColors.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: TColors.primary.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.dataset.title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: TColors.textPrimary,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            widget.resource.title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: TColors.textSecondary,
                  fontSize: 11,
                ),
          ),
          const SizedBox(height: 10),
          _buildMiniDiagram(context),
          const SizedBox(height: 8),
          Text(
            '${_resourceData.total} total baris data • menampilkan ${_resourceData.records.length}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: TColors.primary,
                  fontSize: 11,
                ),
          ),
          const SizedBox(height: 2),
          Text(
            'Gunakan tombol refresh untuk memuat ulang data terbaru dari Satu Data Gresik.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: TColors.primary.withOpacity(0.8),
                  fontSize: 10.5,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniDiagram(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Row(
      children: [
        Expanded(
          child: _ResourceDiagramTile(
            icon: Icons.view_column,
            label: 'Kolom',
            value: _resourceData.columns.length.toString().padLeft(2, '0'),
            color: TColors.primary.withOpacity(0.08),
            textColor: TColors.primary,
            textTheme: textTheme,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _ResourceDiagramTile(
            icon: Icons.table_chart_outlined,
            label: 'Preview',
            value: _resourceData.records.length.toString().padLeft(2, '0'),
            color: TColors.secondary.withOpacity(0.08),
            textColor: TColors.secondary,
            textTheme: textTheme,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _ResourceDiagramTile(
            icon: Icons.storage_rounded,
            label: 'Total',
            value: _resourceData.total.toString(),
            color: TColors.primary.withOpacity(0.12),
            textColor: TColors.primary,
            textTheme: textTheme,
          ),
        ),
      ],
    );
  }

  Widget _buildDataTable() {
    final columns = _resourceData.columns;
    final rows = _resourceData.records;

    return Scrollbar(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          child: DataTable(
            columns: columns
                .map(
                  (column) => DataColumn(
                    label: Text(
                      column,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                )
                .toList(),
            rows: rows.map((record) {
              return DataRow(
                cells: columns
                    .map(
                      (column) => DataCell(
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 200),
                          child: Text(
                            '${record[column] ?? '-'}',
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

