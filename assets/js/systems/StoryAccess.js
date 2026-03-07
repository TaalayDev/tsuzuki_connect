/**
 * Story access policy
 * UNLOCK_ALL_STORIES is initially false, but will be updated by Flutter.
 */
export let UNLOCK_ALL_STORIES = true;
window.UNLOCK_ALL_STORIES = true;
export const MAX_ACCESSIBLE_STORY_NUMBER = 2;

export function setUnlockAllStories(unlocked) {
    UNLOCK_ALL_STORIES = unlocked;
    window.UNLOCK_ALL_STORIES = unlocked;
}

export function getStoryNumber(storyId) {
    const match = typeof storyId === 'string' ? /^story(\d+)$/.exec(storyId) : null;
    return match ? Number.parseInt(match[1], 10) : NaN;
}

export function isStoryAccessible(storyId) {
    if (UNLOCK_ALL_STORIES) return true;
    const storyNumber = getStoryNumber(storyId);
    return Number.isFinite(storyNumber) && storyNumber <= MAX_ACCESSIBLE_STORY_NUMBER;
}

// Make it available to global scope so Flutter can call it easily
window.updateSubscriptionStatus = function (isSubscribed) {
    setUnlockAllStories(isSubscribed);
    console.log("Subscription status updated to: ", isSubscribed);

    // Dispatch an event so UI can react (e.g. Chapter Select screen)
    window.dispatchEvent(new CustomEvent('subscriptionStatusUnlocked', { detail: { isSubscribed } }));
};

// Try to fetch initial status from Flutter immediately
if (window.flutter_inappwebview && window.flutter_inappwebview.callHandler) {
    window.flutter_inappwebview.callHandler('getSubscriptionStatus').then(function (isSubscribed) {
        if (isSubscribed !== undefined) {
            setUnlockAllStories(isSubscribed);
        }
    });
} else {
    // If flutter_inappwebview isn't ready yet, wait for it
    window.addEventListener("flutterInAppWebViewPlatformReady", function (event) {
        window.flutter_inappwebview.callHandler('getSubscriptionStatus').then(function (isSubscribed) {
            if (isSubscribed !== undefined) {
                setUnlockAllStories(isSubscribed);
            }
        });
    });
}
