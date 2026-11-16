import '../../app/l10n/app_localizations.dart';

/// The selected quotation stays stable when the app language changes.
enum SplashQuoteId { shevchenko, forestSong, hope, struggle, awaken }

extension SplashQuoteCopy on SplashQuoteId {
  ({String text, String author}) localized(AppLocalizations l) =>
      switch (this) {
        SplashQuoteId.shevchenko => (
          text: l.splashQuoteShevchenko,
          author: l.splashAuthorShevchenko,
        ),
        SplashQuoteId.forestSong => (
          text: l.splashQuoteForestSong,
          author: l.splashAuthorUkrainka,
        ),
        SplashQuoteId.hope => (
          text: l.splashQuoteHope,
          author: l.splashAuthorUkrainka,
        ),
        SplashQuoteId.struggle => (
          text: l.splashQuoteStruggle,
          author: l.splashAuthorFranko,
        ),
        SplashQuoteId.awaken => (
          text: l.splashQuoteAwaken,
          author: l.splashAuthorFranko,
        ),
      };
}
