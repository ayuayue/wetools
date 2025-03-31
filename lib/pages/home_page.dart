import 'package:flutter/material.dart';
import '../models/tool_model.dart';
import '../data/tools_data.dart';
import '../widgets/breadcrumb_navigation.dart';

class MyHomePage extends StatefulWidget {
  final String title;
  final String? initialToolId;
  final String? initialGroupId;
  final bool scrollToTop;

  const MyHomePage({
    Key? key,
    required this.title,
    this.initialToolId,
    this.initialGroupId,
    this.scrollToTop = false,
  }) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final Map<String, GlobalKey> _groupKeys = {};
  final GlobalKey _searchResultsKey = GlobalKey();

  List<ToolModel> _searchResults = [];
  ToolModel? _selectedTool;
  ToolGroup? _selectedGroup;
  bool _isSearching = false;
  bool _showToolDetail = false;

  @override
  void initState() {
    super.initState();

    // 为每个分组创建一个Key，用于滚动定位
    for (var group in ToolsData.groups) {
      _groupKeys[group.id] = GlobalKey();
    }

    // 处理初始化参数
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _handleInitialNavigation();
    });
  }

  void _handleInitialNavigation() {
    if (widget.scrollToTop) {
      _scrollToTop();
      return;
    }

    if (widget.initialToolId != null) {
      final tool = ToolsData.getToolById(widget.initialToolId!);
      if (tool != null) {
        setState(() {
          _selectedTool = tool;
          _showToolDetail = true;
        });
        return;
      }
    }

    if (widget.initialGroupId != null) {
      final group = ToolsData.getGroupById(widget.initialGroupId!);
      if (group != null) {
        _scrollToGroup(group.id);
        setState(() {
          _selectedGroup = group;
        });
      }
    }
  }

  void _scrollToTop() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  void _scrollToGroup(String groupId) {
    final key = _groupKeys[groupId];
    if (key?.currentContext != null) {
      Scrollable.ensureVisible(
        key!.currentContext!,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  void _scrollToSearchResults() {
    if (_searchResultsKey.currentContext != null) {
      Scrollable.ensureVisible(
        _searchResultsKey.currentContext!,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  void _handleSearch(String query) {
    setState(() {
      _isSearching = query.isNotEmpty;
      _searchResults = ToolsData.searchTools(query);
      _showToolDetail = false;
      _selectedTool = null;
      _selectedGroup = null;
    });

    if (_isSearching && _searchResults.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToSearchResults();
      });
    }
  }

  void _openTool(ToolModel tool) {
    setState(() {
      _selectedTool = tool;
      _showToolDetail = true;
      _searchController.clear();
      _isSearching = false;
      _searchResults = [];
    });
  }

  void _selectGroup(ToolGroup group) {
    setState(() {
      _selectedGroup = group;
      _selectedTool = null;
      _showToolDetail = false;
      _searchController.clear();
      _isSearching = false;
      _searchResults = [];
    });
    _scrollToGroup(group.id);
  }

  void _goHome() {
    setState(() {
      _selectedTool = null;
      _selectedGroup = null;
      _showToolDetail = false;
      _searchController.clear();
      _isSearching = false;
      _searchResults = [];
    });
    _scrollToTop();
  }

  List<BreadcrumbItem> _buildBreadcrumbs() {
    final items = <BreadcrumbItem>[];

    // 首页
    items.add(BreadcrumbItem(
      title: '首页',
      onTap: _goHome,
      isLast: _selectedTool == null && _selectedGroup == null && !_isSearching,
    ));

    // 搜索结果
    if (_isSearching) {
      items.add(BreadcrumbItem(
        title: '搜索结果',
        onTap: () {},
        isLast: true,
      ));
      return items;
    }

    // 分组
    if (_selectedGroup != null) {
      items.add(BreadcrumbItem(
        title: _selectedGroup!.name,
        onTap: () => _selectGroup(_selectedGroup!),
        isLast: _selectedTool == null,
      ));
    }

    // 工具
    if (_selectedTool != null) {
      // 如果没有选择分组，但有选择工具，则添加工具所属分组
      if (_selectedGroup == null) {
        final group = ToolsData.getGroupById(_selectedTool!.groupId);
        if (group != null) {
          items.add(BreadcrumbItem(
            title: group.name,
            onTap: () => _selectGroup(group),
            isLast: false,
          ));
        }
      }

      items.add(BreadcrumbItem(
        title: _selectedTool!.name,
        onTap: () {},
        isLast: true,
      ));
    }

    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // 面包屑导航
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 1,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Row(
              children: [
                BreadcrumbNavigation(items: _buildBreadcrumbs()),
                const Spacer(),
                // 搜索框
                SizedBox(
                  width: 300,
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: '搜索工具...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                                _handleSearch('');
                              },
                            )
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Theme.of(context)
                          .colorScheme
                          .surfaceVariant
                          .withOpacity(0.5),
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    ),
                    onChanged: _handleSearch,
                  ),
                ),
              ],
            ),
          ),

          // 主内容区域
          Expanded(
            child: _showToolDetail ? _buildToolDetailPage() : _buildHomePage(),
          ),
        ],
      ),
    );
  }

  Widget _buildToolDetailPage() {
    if (_selectedTool == null) return const SizedBox.shrink();
    return _selectedTool!.page;
  }

  Widget _buildHomePage() {
    return ListView(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      children: [
        // 搜索结果
        if (_isSearching) ...[
          Container(
            key: _searchResultsKey,
            margin: const EdgeInsets.only(bottom: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '搜索结果 (${_searchResults.length})',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                if (_searchResults.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: Text('没有找到匹配的工具'),
                    ),
                  )
                else
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      childAspectRatio: 1.5,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: _searchResults.length,
                    itemBuilder: (context, index) {
                      final tool = _searchResults[index];
                      return _buildToolCard(tool);
                    },
                  ),
              ],
            ),
          ),
        ],

        // 工具分组
        ...ToolsData.groups.map((group) {
          final groupTools = ToolsData.getToolsByGroup(group.id);
          return Container(
            key: _groupKeys[group.id],
            margin: const EdgeInsets.only(bottom: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      group.icon,
                      color: group.color,
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      group.name,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      group.description,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.6),
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    childAspectRatio: 1.5,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: groupTools.length,
                  itemBuilder: (context, index) {
                    final tool = groupTools[index];
                    return _buildToolCard(tool);
                  },
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildToolCard(ToolModel tool) {
    final group = ToolsData.getGroupById(tool.groupId);
    final color = group?.color ?? Colors.grey;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _openTool(tool),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                tool.icon,
                size: 32,
                color: color,
              ),
              const SizedBox(height: 12),
              Text(
                tool.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                tool.description,
                style: TextStyle(
                  fontSize: 12,
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
