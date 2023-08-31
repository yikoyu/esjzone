/*
 * @Date: 2023-08-25 10:35:35
 * @LastEditors: yikoyu 2282373181@qq.com
 * @LastEditTime: 2023-08-31 10:53:07
 * @FilePath: \esjzone\lib\app\utils\esjzone\esjzone_selector.dart
 */
import 'package:esjzone/app/data/comment_list_model.dart';
import 'package:esjzone/app/data/novel_chapter_list_model.dart';
import 'package:esjzone/app/data/novel_detail_model.dart';
import 'package:esjzone/app/data/novel_detail_star_model.dart';
import 'package:esjzone/app/data/novel_list_model.dart';
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
      'description': q('#details .description')?.innerHtml
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
}

class _EsjzoneSelectorSub {
  /// 转换章节列表----章节项
  static Map<String, String?> chapterTypeChapterItem(Element e) {
    String? href = e.attributes['href'];

    List<String>? idList = href
        ?.split(RegExp(r'/|\.'))
        .where((e) => int.tryParse(e) != null)
        .toList();

    bool hasNovelId = isURL(href) && idList != null && idList.isNotEmpty;
    bool hasChapterId = isURL(href) && idList != null && idList.length > 1;

    return {
      'type': 'chapter',
      'title': e.text,
      'title_html': e.innerHtml,
      'link': href,
      'novel_id': hasNovelId ? idList[0] : null,
      'chapter_id': hasChapterId ? idList[1] : null,
    };
  }
}
