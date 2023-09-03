/*
 * @Date: 2023-08-25 10:35:35
 * @LastEditors: yikoyu 2282373181@qq.com
 * @LastEditTime: 2023-09-03 16:49:17
 * @FilePath: \esjzone\lib\app\utils\esjzone\esjzone_selector.dart
 */
import 'package:esjzone/app/data/comment_list_model.dart';
import 'package:esjzone/app/data/novel_chapter_list_model.dart';
import 'package:esjzone/app/data/novel_detail_model.dart';
import 'package:esjzone/app/data/novel_detail_star_model.dart';
import 'package:esjzone/app/data/novel_list_model.dart';
import 'package:esjzone/app/data/novel_read_model.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:string_validator/string_validator.dart';

class EsjzoneSelector {
  /// 获取授权
  static String getAuthToken(String? input) {
    if (input == null || input.isEmpty) {
      return '';
    }

    Document doc = parse(input);
    Element? row = doc.querySelector('JinJing');

    if (row == null) {
      return '';
    }

    return row.text;
  }

  /// 获取小说列表（列表页、搜索页）
  static List<NovelList> novelList(String? input) {
    if (input == null || input.isEmpty) {
      return <NovelList>[];
    }

    const SELECTOR_ROW =
        'body > div.offcanvas-wrapper > section > div > div.col-xl-9.col-lg-8.p-r-30 > div.row';

    Document doc = parse(input);
    Element? row = doc.querySelector(SELECTOR_ROW);

    if (row == null) {
      return <NovelList>[];
    }

    Iterable<NovelList> items = row.children.map((col) {
      var q = col.querySelector;

      String? img = q('> .main-img > .lazyload')?.attributes['data-src'];
      String? link = q('> h5.card-title > a')?.attributes['href'];

      List<String>? idList = link
          ?.split(RegExp(r'/|\.'))
          .where((e) => int.tryParse(e) != null)
          .toList();

      return NovelList.fromJson({
        'id': idList?[0],
        'title': q('> h5.card-title > a')?.text,
        'link': q('> h5.card-title > a')?.attributes['href'],
        'img': isURL(img) ? img : null,
        'author': q('> .card-author > a')?.text,
        'last_ep': q('> .card-ep > a')?.text,
        'last_ep_link': q('> .card-ep > a')?.attributes['href'],
        'last_chapter_id': _EsjzoneSelectorUtils.getChapterId(
            q('> .card-ep > a')?.attributes['href']),
        'stars': q('> i.icon-star-s')?.parent?.text.trim(),
        'words': q('> i.icon-file-text')?.parent?.text.trim(),
        'views': q('> i.icon-eye')?.parent?.text.trim(),
        'favorite': q('> i.icon-heart')?.parent?.text.trim(),
        'feathers': q('> i.icon-feather')?.parent?.text.trim(),
        'messages': q('> i.icon-message-square')?.parent?.text.trim(),
        'x_rated': q('> .product-badge')?.text == '18+'
      });
    });

    return items.toList();
  }

  /// 获取热门tag（列表页、详情页）
  static List<String> hotTagList(String? input) {
    if (input == null || input.isEmpty) {
      return <String>[];
    }

    const SELECTOR_TAG = 'body > div.offcanvas-wrapper .widget.widget-tags > a';

    Document doc = parse(input);
    List<Element>? tagElList = doc.querySelectorAll(SELECTOR_TAG);
    List<String> tags = tagElList.map((e) => e.text).toSet().toList();

    return tags;
  }

  /// 获取评论列表（详情页，小说页）
  static List<CommentList> commentList(String? input) {
    if (input == null || input.isEmpty) {
      return [];
    }

    Document doc = parse(input);
    List<Element> commentsSectionlist =
        doc.querySelectorAll('.comments-section .comment-body');

    Iterable<CommentList> items = commentsSectionlist.map((item) {
      var q = item.querySelector;

      return CommentList.fromJson({
        'poster': q('.comment-title > a')?.text,
        'poster_link': q('.comment-title > a')?.attributes['href'],
        'poster_uid': q('.comment-title > a')
            ?.attributes['href']
            ?.split(RegExp(r'uid='))[1],
        'floor': q('.column > .comment-meta.comment-floor')?.text,
        'create_time': q('.column > .comment-meta:last-child')?.text,
        'reply_from': q('blockquote > p')?.text,
        'reply_to': q('.comment-text')?.text,
        'reply_to_html': q('.comment-text')?.innerHtml
      });
    });

    return items.toList();
  }

  /// 获取小说详情（详情页）
  static NovelDetail novelDetail(String? input) {
    if (input == null || input.isEmpty) {
      return NovelDetail.fromJson({});
    }

    Document doc = parse(input);
    var q = doc.querySelector;

    List<Element> detailEL =
        doc.querySelectorAll('ul.list-unstyled.book-detail > li');

    Map<String, String?> detail = {};

    // 作品信息
    for (Element i in detailEL) {
      if (i.text.contains('類型')) {
        detail['category'] = i.text.split(': ').reversed.toList()[0];
      }
      if (i.text.contains('作者')) {
        detail['author'] = i.text.split(': ').reversed.toList()[0];
      }
      if (i.text.contains('其他書名')) {
        detail['other_title'] = i.text.split(': ').reversed.toList()[0];
      }
      if (i.text.contains('Web生肉')) {
        detail['raw_novel_link'] = i.querySelector('a')?.attributes['href'];
      }
      if (i.text.contains('更新日期')) {
        detail['update_time'] = i.text.split(': ').reversed.toList()[0];
      }
    }

    // 相关链接
    Iterable<Map<String, dynamic>> relatedLinkList = doc
        .querySelectorAll('div.book-detail > .out-link a')
        .map((e) => {'href': e.attributes['href'], 'text': e.text});

    return NovelDetail.fromJson({
      ...detail,
      'img': q('div.product-gallery.text-center.mb-3 > a > img')
          ?.attributes['src'],
      'title': q('div.col-md-9.book-detail > h2')?.text,
      'views': q('div.col-md-9.book-detail #vtimes')?.text,
      'favorite': q('div.col-md-9.book-detail #favorite')?.text,
      'words': q('div.col-md-9.book-detail #txt')?.text,
      'isFavorite':
          q('div.col-md-9.book-detail button.btn-favorite > span')?.text ==
              '已收藏',
      'relatedLinkList': relatedLinkList.toList(),
      'description': q('#details .description')?.innerHtml,
      'active_chapter_id': _EsjzoneSelectorUtils.getChapterId(
          q('.row .tab-content #chapterList a > p.active')
              ?.parent
              ?.attributes['href'])
    });
  }

  /// 获取小说评分（详情页）
  static NovelDetailStar novelDetailStar(String? input) {
    if (input == null || input.isEmpty) {
      return NovelDetailStar.fromJson({});
    }

    Document doc = parse(input);
    var q = doc.querySelector;

    List<String> rateList = doc
        .querySelectorAll('.card.hidden-lg-up > .card-body label')
        .map((e) =>
            e
                .querySelector('> .text-muted')
                ?.text
                .split(' ')
                .reversed
                .toList()[0] ??
            '0')
        .toList();

    return NovelDetailStar.fromJson({
      'totalRate':
          q('div.col-md-9.book-detail > ul > li.hidden-md-up > div > div.d-inline.align-baseline')
              ?.text,
      'oneRate': rateList[0],
      'twoRate': rateList[1],
      'threeRate': rateList[2],
      'fourRate': rateList[3],
      'fiveRate': rateList[4],
    });
  }

  /// 获取小说章节（详情页）
  static List<NovelChapterList> novelChapterList(String? input) {
    if (input == null || input.isEmpty) {
      return <NovelChapterList>[];
    }

    Document doc = parse(input);
    List<Element> chapterListEL =
        doc.querySelector('.row .tab-content #chapterList')?.children ?? [];
    Iterable<NovelChapterList> chapterList = chapterListEL.map((e) {
      // 普通文本
      // bool isText = e.className.contains('non');

      // 普通章节
      if (e.localName == 'a') {
        var chapter = _EsjzoneSelectorSub.chapterTypeChapterItem(e);
        return NovelChapterList.fromJson(chapter);
      }

      // 折叠
      if (e.localName == 'details') {
        Iterable<Map<String, String?>> chapters =
            e.querySelectorAll('> a').map((c) {
          return _EsjzoneSelectorSub.chapterTypeChapterItem(c);
        });

        return NovelChapterList.fromJson({
          'type': 'details',
          'title': e.querySelector('> summary')?.text,
          'title_html': e.querySelector('> summary')?.innerHtml,
          'chapters': chapters.toList()
        });
      }

      return NovelChapterList.fromJson(
          {'type': 'text', 'title': e.text, 'title_html': e.outerHtml});
    });

    return chapterList.toList();
  }

  /// 获取小说章节内容（阅读页）
  static NovelRead novelRead(String? input) {
    if (input == null || input.isEmpty) {
      return NovelRead();
    }

    var q = parse(input).querySelector;

    var authorEl = q('.single-post-meta:not(.file-text) > .column > a');
    var chapterPrevEl =
        q('.entry-navigation > div.column.text-left > .btn-prev');
    var chapterNextEl =
        q('.entry-navigation > div.column.text-right > .btn-next');

    String? chapterId =
        q('.form-group > input[name="forum_id"]')?.attributes['value'];
    String? novelName = q('ul.breadcrumbs > li:last-child > a')?.text;
    String? chapterName = q('.row  h2')?.text;
    String? contentHtml = q('.forum-content')?.outerHtml;
    String? updateTime =
        q('.single-post-meta:not(.file-text) > .column:last-child')
            ?.text
            .trim();
    String? words = q('.single-post-meta.file-text span#file-text')?.text;

    return NovelRead.fromJson({
      'novel_id': q('.sp-buttons > a[data-code]')?.attributes['data-code'],
      'novel_name': novelName,
      'likes': q('.sp-buttons > a[data-code] > #likes')?.text,
      'is_like':
          q('.sp-buttons > a[data-code]')?.className.contains('btn-warning') ??
              false,
      'chapter_id': chapterId,
      'chapter_name': chapterName,
      'chapter_prev_id':
          _EsjzoneSelectorUtils.getChapterId(chapterPrevEl?.attributes['href']),
      'chapter_prev_name': chapterPrevEl?.attributes['data-title'],
      'chapter_next_id':
          _EsjzoneSelectorUtils.getChapterId(chapterNextEl?.attributes['href']),
      'chapter_next_name': chapterNextEl?.attributes['data-title'],
      'content_html': contentHtml,
      'author_id': authorEl?.attributes['href']?.split(RegExp(r'uid='))[1],
      'author_name': authorEl?.text,
      'update_time': updateTime,
      'words': words,
    });
  }
}

class _EsjzoneSelectorSub {
  /// 转换章节列表----章节项
  static Map<String, String?> chapterTypeChapterItem(Element e) {
    String? href = e.attributes['href'];

    return {
      'type': 'chapter',
      'title': e.text,
      'title_html': e.innerHtml,
      'link': href,
      'novel_id': _EsjzoneSelectorUtils.getNovelId(href),
      'chapter_id': _EsjzoneSelectorUtils.getChapterId(href),
    };
  }
}

class _EsjzoneSelectorUtils {
  /// 解析小说URL
  static List<String> parseChapterURL(String? url) {
    if (!isURL(url)) return [];

    if (url != null && url.isNotEmpty) {
      return url
          .split(RegExp(r'/|\.'))
          .where((e) => int.tryParse(e) != null)
          .toList();
    }

    return [];
  }

  /// 获取小说ID
  static String? getNovelId(String? url) {
    List<String> idList = parseChapterURL(url);

    return idList.isNotEmpty ? idList[0] : null;
  }

  // 获取章节ID
  static String? getChapterId(String? url) {
    List<String> idList = parseChapterURL(url);

    return idList.length > 1 ? idList[1] : null;
  }
}
